## Copyright (C) 2016-2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function [clear_req, s, varargout] = run_command(c, cargs, cf, o, s1, ~, aname)

    s = build_outman_config_stru(s1, cf, o);
    s = set_encoding_check_func(s, cf);

    clear_req = checkmtree_command(c, 'quit_command');

    oId = outman_connect_and_config_if_master(s.outman_config_stru);

    if checkmtree_command(c, 'tree_checking_command')

        if numel(cargs) == 0
            top = pwd;
        else
            top = cargs{1};
        endif

        outman('logtimef', oId, '%s(''%s'') launched', aname, c);
        startTime = now;
        log_dirs_err_if_non_existent('Analysed tree(s):', top)

        if checkmtree_command(c, 'dependencies_checking_command')

            # Do the dependencies analysis.
            sM = read_declared_dependencies(...
                compute_dependencies(find_m_toolboxes(top)));

            # Get Toolman's configuration.
            toolmanAlreadyRunning = mislocked('toolman');
            toolmanCf = toolman('get_config');
            if ~toolmanAlreadyRunning
                toolman('quit');
            endif

            # Find test cases and test case toolboxes.
            sM = detect_test_cases(sM, ...
                toolmanCf.test_case_tb_reg_exp, toolmanCf.test_case_reg_exp);

            s.deps = sM;
        else

            # Explore the toolboxes only.
            sM = find_m_toolboxes(top);
        endif

        varargout{1} = check_tree(oId, s, cf, sM, c, startTime, aname);

    elseif checkmtree_command(c, 'listing_command')

        if ~isfield(s, 'deps')
            error(['Command %s is unavailable. Please issue a ' ...
                '%s(''dependencies'', ...) or ' ...
                '%s(''all'', ...) command'], c, aname, aname);
        endif

        outman('logtimef', oId, '%s(''%s'') output:', aname, c);
        startTime = now;

        if checkmtree_command(c, 'toolbox_dependencies_listing')
            varargout{1} = toolbox_deps(oId, s.deps, cargs);
        else
            varargout{1} = list_deps(oId, s.deps);
        endif

        outman('logtimef', oId, ...
            'End of %s(''%s'') output (took %s)\n', ...
            aname, c, duration_str(now - startTime));

    elseif strcmp(c, 'configure')
        varargout{1} = cf;
    elseif strcmp(c, 'get_config_origin')
        varargout{1} = o;

    endif

    outman('disconnect', oId);

endfunction

# -----------------------------------------------------------------------------

# Build configuration structure for Outman.

function s = build_outman_config_stru(s1, cf, o)

    s = s1;
    if ~isfield(s1, 'outman_config_stru')
        s.outman_config_stru = strip_defaults_from_config_stru(...
                clean_up_struct(cf, fieldnames(outman_config_stru)), o);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set the encoding checking function.

function s = set_encoding_check_func(s1, cf)

    s = s1;
    if ~isfield(s1, 'encoding_check_func')

        switch cf.m_file_char_set

            case 'ascii'
                s.encoding_check_func = @is_ascii_bytes_vect;

            case 'iso8859'
                s.encoding_check_func = @is_iso_8859_bytes_vect;

            case 'utf8'
                s.encoding_check_func = @is_utf8_bytes_vect;

            case 'win1252'
                s.encoding_check_func = @is_win_1252_bytes_vect;

        endswitch

    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check M-files tree.

function s_c = check_tree(o_id, s, cf, s_m, c, start_time, appname)

    mFilt = m_file_filters ('m_lang_only');
    mExt = file_ext(mFilt{1});
    s_c = struct('m_file_count', 0, 'max_m_file_byte_size', 0);
    if checkmtree_command(c, 'dependencies_checking_command')
        s_c.cum_line_count ...
            = sum(cellfun(@sum, s_m.mfilelinecount)) ...
            + sum(cellfun(@sum, s_m.privatemfilelinecount));
        s_c.cum_sloc_count = 0;
        s_c.cum_test_sloc_count = 0;
        for tBIdx = 1 : numel(s_m.toolboxpath)
            tBSLOCCount = sum(s_m.mfilesloc{tBIdx});
            if s_m.privateidx(tBIdx) ~= 0
                tBSLOCCount = tBSLOCCount ...
                    + sum(s_m.privatemfilesloc{s_m.privateidx(tBIdx)});
            endif
            s_c.cum_sloc_count = s_c.cum_sloc_count + tBSLOCCount;
            if any(s_m.testcasetb == tBIdx)
                s_c.cum_test_sloc_count = s_c.cum_test_sloc_count ...
                    + tBSLOCCount;
            endif
        endfor
    endif

    checkCodeAvail = true;
    if checkmtree_command(c, 'code_checking_command') ...
            && isempty(which('checkcode'))
        checkCodeAvail = false;
        outman('errorf', o_id, ['Function checkcode does not seem to be ' ...
            'available. Cannot perform code checking.']);
    endif

    cumBytes = m_files_cum_byte_size(s_m);

    pId = outman('init_progress', o_id, 0, cumBytes, ...
        'Checking the tree...');
    p = 0;
    for tBIdx = 1 : numel(s_m.toolboxpath)

        if s_m.privateidx(tBIdx) ~= 0
            file = [s_m.mfiles{tBIdx} ...
                fullfile(s_m.privatesubdir, ...
                    s_m.privatemfiles{s_m.privateidx(tBIdx)})];
            bytes = [s_m.mfilebytes{tBIdx} ...
                s_m.privatemfilebytes{s_m.privateidx(tBIdx)}];
        else
            file = s_m.mfiles{tBIdx};
            bytes = s_m.mfilebytes{tBIdx};
        endif

        for fileIdx = 1 : numel(file)
            isMFile = strcmp(file_ext(file{fileIdx}), mExt);
            absPath = fullfile(s_m.toolboxpath{tBIdx}, file{fileIdx});

            if isMFile ...
                    && (checkmtree_command(c, 'encoding_checking_command') ...
                    || checkmtree_command(c, 'dependencies_checking_command'))
                check_encoding(absPath, o_id, s, cf);
            endif

            if checkCodeAvail ...
                    && checkmtree_command(c, 'code_checking_command') ...
                    && isMFile
                try_checkcode(absPath, o_id);
            endif

            if isMFile && bytes(fileIdx) > s_c.max_m_file_byte_size
                s_c.max_m_file_byte_size = bytes(fileIdx);
            endif

            if isMFile
                s_c.m_file_count = s_c.m_file_count + 1;
                p = p + bytes(fileIdx);
                outman('update_progress', o_id, pId, p);
            endif
        endfor

        if checkmtree_command(c, 'dependencies_checking_command')
            declDep = s_m.decl_dep{tBIdx};
            compDep = s_m.comp_dep{tBIdx};
            for k = 1 : numel(declDep)
                if ~any(compDep == declDep(k))
                    outman('warningf', o_id, ...
                        ['%s is a declared dependency for %s but code ' ...
                        'analysis did not confirm this dependency'], ...
                        s_m.toolboxpath{declDep(k)}, s_m.toolboxpath{tBIdx});
                endif
            endfor
            for k = 1 : numel(compDep)
                if ~any(declDep == compDep(k))
                    outman('errorf', o_id, ...
                        ['Code analysis found that %s is a dependency for ' ...
                        '%s and this dependency is not declared'], ...
                        s_m.toolboxpath{compDep(k)}, s_m.toolboxpath{tBIdx});
                endif
            endfor
        endif

    endfor
    outman('terminate_progress', o_id, pId);
    outman('logf', o_id, '');
    outman('logtimef', o_id, '%s(''%s'') done (took %s)', appname, c, ...
        duration_str(now - start_time));
    outman('logf', o_id, ...
        '%d analyzed M-files (%d bytes for the larger file)', ...
        s_c.m_file_count, s_c.max_m_file_byte_size);
    if isfield(s_c, 'cum_line_count')
        if s_c.cum_line_count ~= 0
            outman('logf', o_id, ...
                ['%d lines of text in the analyzed M-files, ' ...
                '%d of them are SLOC (%.2f%%)'], s_c.cum_line_count, ...
                s_c.cum_sloc_count, ...
                s_c.cum_sloc_count / s_c.cum_line_count * 100);
        else
            outman('logf', o_id, ...
                '%d lines of text in the analyzed M-files', ...
                s_c.cum_line_count);
        endif
    endif
    outman('logf', o_id, '');
endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Run checkcode and display the output if any, issue an error message if
# checkcode fails.

function try_checkcode(filename, o_id)

    msg = '';
    try
        msg = checkcode(filename, '-string', '-fullpath');
    catch
        outman('errorf', o_id, 'checkcode failed while analyzing %s', ...
            filename);
    end_try_catch
    if ~isempty(msg)
        outman('printf', o_id, '\n%s:\n%s\n', filename, msg);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check file encoding.

function check_encoding(filename, o_id, s, cf)

    try
        if ~is_ascii_file(filename, s.encoding_check_func, cf.max_read_bytes)
            outman('errorf', o_id, '%s is no %s encoded file', ...
                filename, cf.m_file_char_set);
        endif
    catch
        outman('errorf', o_id, 'Could not check the encoding of %s', ...
            filename);
    end_try_catch

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# List calls made to other toolboxes by a toolbox.

function c = toolbox_deps(o_id, s, cargs)

    c = {};
    kTB = toolbox_index(s, cargs{1});
    nTB = numel(s.toolboxpath);
    if isscalar(kTB)
        c = s.externalfuncs{kTB};
        n = numel(c);
        c = [c; cell(1, n)];
        for k = 1 : n
            kk = 0;
            while isempty(c{2, k}) && kk < nTB
                kk = kk + 1;
                if kk ~= kTB && any(strcmp(...
                        strip_dot_suffix(s.mfiles{kk}), c{1, k}))
                    c{2, k} = s.toolboxpath{kk};
                endif
            endwhile
        endfor

        flag = false(1, n);
        for k = 1 : n
            if ~flag(k)
                if ~any(flag)
                    outman('printf', o_id, ...
                        '%s depends on:', s.toolboxpath{kTB});
                endif
                depName = c{2, k};
                outman('printf', o_id, '  %s', depName);
                for kk = k : n
                    if ~flag(kk) && strcmp(depName, c{2, kk})
                        outman('printf', o_id, '    function %s', c{1, kk});
                        flag(kk) = true;
                    endif
                endfor
            endif
        endfor
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return the number of dependencies.

function ret = deps_count(s)

    ret = 0;
    for kTB = 1 : numel(s.toolboxpath)
        ret = ret + cell_cum_numel(s.mfileexternalfuncs{kTB});
    endfor
    for kP = 1 : numel(s.privatemfiles)
        ret = ret + cell_cum_numel(s.privatemfileexternalfuncs{kP});
    endfor

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# List the dependencies for every M-file.

function c = list_deps(o_id, s)

    depsCount = deps_count(s);
    c = cell(depsCount, 5);
    pId = outman('init_progress', o_id, 0, depsCount, ...
        'Listing per M-file dependencies...');
    for kTB = 1 : numel(s.toolboxpath)
        tBHeaderDone = false;
        [c, tBHeaderDone] = print_deps_list(o_id, pId, 'public', kTB, c, ...
            tBHeaderDone, s.toolboxpath, s.mfiles, s.mfiles{kTB}, ...
            s.mfileexternalfuncs{kTB});

        if s.privateidx(kTB) ~= 0
            kP = s.privateidx(kTB);

            c = print_deps_list(o_id, pId, 'private', kTB, c, tBHeaderDone, ...
                s.toolboxpath, s.mfiles, s.privatemfiles{kP}, ...
                s.privatemfileexternalfuncs{kP});
        endif
    endfor
    outman('terminate_progress', o_id, pId);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Print per M-file dependencies list.

function [c, h] = print_deps_list(...
        o_id, p_id, kw, k_t_b, c1, h1, t_b_p, pub_m_f, m_f, e_f)

    c = c1;
    h = h1;

    level = find(cellfun(@isempty, c(:, 1)), 1);

    nM = numel(m_f);
    for kM = 1 : nM
        n = numel(e_f{kM});
        cc = [e_f{kM}; cell(1, n)];
        for k = 1 : n
            kk = 0;
            while isempty(cc{2, k}) && kk < numel(t_b_p)
                kk = kk + 1;
                if kk ~= k_t_b && any(strcmp(...
                        strip_dot_suffix(pub_m_f{kk}), cc{1, k}))
                    cc{2, k} = t_b_p{kk};
                endif
            endwhile
        endfor

        flag = false(1, n);
        for k = 1 : n
            if ~h
                outman('printf', o_id, 'In toolbox %s', t_b_p{k_t_b});
                h = true;
            endif
            if ~flag(k)
                if ~any(flag)
                    f = strip_dot_suffix(m_f{kM});
                    outman('printf', o_id, '  %s function %s depends on:', ...
                        kw, f);
                endif
                depName = cc{2, k};
                outman('printf', o_id, '    %s', depName);
                for kk = k : n
                    if ~flag(kk) && strcmp(depName, cc{2, kk})
                        outman('printf', o_id, '      function %s', ...
                            cc{1, kk});
                        flag(kk) = true;
                        c{level, 1} = f;
                        c{level, 2} = kw;
                        c{level, 3} = t_b_p{k_t_b};
                        c{level, 4} = cc{1, kk};
                        c{level, 5} = depName;
                        outman('update_progress', o_id, p_id, level);
                        level = level + 1;
                    endif
                endfor
            endif
        endfor
    endfor

endfunction

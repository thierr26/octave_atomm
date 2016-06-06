## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function [clear_req, s, varargout] = run_command(c, cargs, cf, o, s1, ~)

    clear_req = false;
    varargout{1} = [];
    s = build_outman_config_stru(s1, cf, o);
    s = set_encoding_check_func(s, cf);

    if any(strcmp(c, {'code', 'dependencies', 'encoding', 'all'}))
        if numel(cargs) == 0
            top = pwd;
        else
            top = cargs{1};
        endif
        oId = outman_connect_and_config_if_master(s.outman_config_stru);
        outman('logtimef', oId, 'checkmtree(''%s'') launched', c);
        if ischar(top)
            absPath = {absolute_path(top)};
            outman('logf', oId, '\nAnalysed tree:\n%s\n', absPath{1});
        else
            if numel(top) == 1
                absPath = {absolute_path(top{1})};
                outman('logf', oId, '\nAnalysed tree:\n%s\n', absPath{1});
            else
                absPath = top;
                outman('logf', oId, '\nAnalysed trees:');
                for k = 1 : numel(top)
                    absPath{k} = absolute_path(top{k});
                    outman('logf', oId, '%s', absPath{k});
                endfor
                outman('logf', oId, '');
            endif
        endif
        err_msg_for_non_existant_tops(absPath, oId);
    endif
    if any(strcmp(c, {'code', 'encoding'}))
        sM = find_m_toolboxes(top, true);
    elseif any(strcmp(c, {'dependencies', 'all'}))
        sM = read_declared_dependencies(...
            compute_dependencies(find_m_toolboxes(top)));
        s.deps = sM;
        s.top = top;
    endif
    if any(strcmp(c, {'code', 'dependencies', 'encoding', 'all'}))
        outman('disconnect', oId);
    endif

    if any(strcmp(c, {'toolbox_deps', 'deps_stru'}))
        if ~isfield(s, 'deps')
            error(['Command %s is unavailable. Please issue a ' ...
                'checkmtree(''dependencies'', ...) or ' ...
                'checkmtree(''all'', ...) command'], c);
        else
            oId = outman_connect_and_config_if_master(s.outman_config_stru);
            outman('logtimef', oId, 'checkmtree(''%s'') output:', c);
        endif
    endif

    switch c

        case 'quit'
            clear_req = true;

        case 'configure'
            1;

        case {'code', 'dependencies', 'encoding', 'all'}
            varargout{1} = check_tree(s, cf, cargs, sM, c);

        case 'toolbox_deps'
            varargout{1} = toolbox_deps(s.deps, cargs, s.outman_config_stru);

        case 'deps_stru'
            varargout{1} = deps_stru(s.deps, s.outman_config_stru);

        otherwise
            error('Internal error: Command %s not handled', c);

    endswitch

    if any(strcmp(c, {'toolbox_deps', 'deps_stru'}))
        outman('logtimef', oId, 'End of checkmtree(''%s'') output\n', c);
        outman('disconnect', oId);
    endif

endfunction

# -----------------------------------------------------------------------------

# Build configuration structure for Outman.

function s = build_outman_config_stru(s1, cf, o)

    s = s1;
    if ~isfield(s1, 'outman_config_stru')
        s.outman_config_stru = rmfield(cf, ...
            {'m_file_char_set', 'max_read_bytes'});
        [c, n] = field_names_and_count(s.outman_config_stru);
        for k = 1 : n
            if strcmp(o.(c{k}), 'Default')
                s.outman_config_stru = rmfield(s.outman_config_stru, c{k});
            endif
        endfor
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

function s_c = check_tree(s, cf, cargs, s_m, c)

    s_c = struct('m_file_count', ...
        cell_cum_numel(s_m.mfiles) + cell_cum_numel(s_m.privatemfiles), ...
        'max_m_file_byte_size', 0);
    if any(strcmp(c, {'all', 'dependencies'}))
        s_c.cum_line_count ...
            = sum(cellfun(@sum, s_m.mfilelinecount)) ...
            + sum(cellfun(@sum, s_m.privatemfilelinecount));
        s_c.cum_sloc_count ...
            = sum(cellfun(@sum, s_m.mfilesloc)) ...
            + sum(cellfun(@sum, s_m.privatemfilesloc));
    endif

    oId = outman_connect_and_config_if_master(s.outman_config_stru);

    checkCodeAvail = true;
    if any(strcmp(c, {'code', 'all'})) && isempty(which('checkcode'))
        checkCodeAvail = false;
        outman('errorf', oId, ...
            'Function checkcode does not seem to be available');
    endif

    cumBytes = sum(cellfun(@(x) sum(x), s_m.mfilebytes)) ...
        + sum(cellfun(@(x) sum(x), s_m.privatemfilebytes));

    pId = outman('init_progress', oId, 0, cumBytes, ...
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
            [~, ~, ext] = fileparts(file{fileIdx});
            isMFile = strcmp(ext, '.m');
            absPath = fullfile(s_m.toolboxpath{tBIdx}, file{fileIdx});

            if any(strcmp(c, {'dependencies', 'encoding', 'all'})) && isMFile
                check_encoding(absPath, oId, s, cf);
            endif

            if checkCodeAvail && any(strcmp(c, {'code', 'all'})) && isMFile
                try_checkcode(absPath, oId);
            endif

            if bytes(fileIdx) > s_c.max_m_file_byte_size
                s_c.max_m_file_byte_size = bytes(fileIdx);
            endif
            p = p + bytes(fileIdx);
            outman('update_progress', oId, pId, p);
        endfor

        if any(strcmp(c, {'dependencies', 'all'}))
            declDep = s_m.decl_dep{tBIdx};
            compDep = s_m.comp_dep{tBIdx};
            for k = 1 : numel(declDep)
                if ~any(compDep == declDep(k))
                    outman('warningf', oId, ...
                        ['%s is a declared dependency for %s but code ' ...
                        'analysis did not confirm this dependency'], ...
                        s_m.toolboxpath{declDep(k)}, s_m.toolboxpath{tBIdx});
                endif
            endfor
            for k = 1 : numel(compDep)
                if ~any(declDep == compDep(k))
                    outman('errorf', oId, ...
                        ['Code analysis found that %s is a dependency for ' ...
                        '%s and this dependency is not declared'], ...
                        s_m.toolboxpath{compDep(k)}, s_m.toolboxpath{tBIdx});
                endif
            endfor
        endif

    endfor
    outman('terminate_progress', oId, pId);
    outman('logf', oId, '');
    outman('logtimef', oId, 'checkmtree(''%s'') done\n', c);
    outman('disconnect', oId);
endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Issue an error message if the argument does not exist as a directory

function err_msg_for_non_existant_tops(dirname, o_id)

    for k = 1 : numel(dirname)
        if exist(dirname{k}, 'dir') ~= 7
            outman('errorf', o_id, 'Directory %s does not exist', dirname{k});
        endif
    endfor

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Run checkcode and display the output if any, issue an error message if
# checkcode fails.

function try_checkcode(filename, o_id)

    msg = '';
    try
        msg = checkcode(filename, '-string', '-fullpath');
    catch
        outman('errorf', o_id, 'checkcode failed while analysing %s', ...
            filename);
    end_try_catch
    if ~isempty(msg)
        outman('printf', o_id, '%s:\n%s\n', filename, msg);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check file encoding.

function check_encoding(filename, o_id, s, cf)

    try
        if ~is_ascii_file(filename, s.encoding_check_func, cf.max_read_bytes);
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

function c = toolbox_deps(s, cargs, outman_config_stru);

    oId = outman_connect_and_config_if_master(outman_config_stru);
    c = {};
    kTB = toolbox_index(s, cargs{1});
    nTB = numel(s.toolboxpath);
    if isscalar(kTB)
        c = s.external_funcs{kTB};
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
                    outman('printf', oId, ...
                        '%s depends on:', s.toolboxpath{kTB});
                endif
                depName = c{2, k};
                outman('printf', oId, '\t%s', depName);
                for kk = k : n
                    if ~flag(kk) && strcmp(depName, c{2, kk})
                        outman('printf', oId, '\t\tfunction %s', c{1, kk});
                        flag(kk) = true;
                    endif
                endfor
            endif
        endfor
    endif
    outman('disconnect', oId);

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

# List the dependencies for each and every M-file.

function c = deps_stru(s, outman_config_stru);

    oId = outman_connect_and_config_if_master(outman_config_stru);
    depsCount = deps_count(s);
    c = cell(depsCount, 5);
    pId = outman('init_progress', oId, 0, depsCount, ...
        'Listing per M-file dependencies...');
    p = 0;
    for kTB = 1 : numel(s.toolboxpath)
        tBHeaderDone = false;
        [c, tBHeaderDone] = print_deps_list(oId, pId, 'public', kTB, c, ...
            tBHeaderDone, s.toolboxpath, s.mfiles, s.mfiles{kTB}, ...
            s.mfileexternalfuncs{kTB});

        if s.privateidx(kTB) ~= 0
            kP = s.privateidx(kTB);

            [c, tBHeaderDone] = print_deps_list(oId, pId, 'private', kTB, ...
                c, tBHeaderDone, s.toolboxpath, s.mfiles, ...
                s.privatemfiles{kP}, s.privatemfileexternalfuncs{kP});
        endif
    endfor
    outman('terminate_progress', oId, pId);
    outman('disconnect', oId);
    assert(isempty(find(cellfun(@isempty, c(:, 1)), 1)));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Print per M-file dependencies list.

function [c, h] ...
    = print_deps_list(o, p_id, kw, k_t_b, c1, h1, t_b_p, pub_m_f, m_f, e_f)

    c = c1;
    h = h1;

    level = find(cellfun(@isempty, c(:, 1)), 1);

    nM = numel(m_f);
    for kM = 1 : nM
        cc = e_f{kM};
        n = numel(cc);
        cc = [cc; cell(1, n)];
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
                outman('printf', o, 'In toolbox %s', t_b_p{k_t_b});
                h = true;
            endif
            if ~flag(k)
                if ~any(flag)
                    f = strip_dot_suffix(m_f{kM});
                    outman('printf', o, '\t%s function %s depends on:', kw, f);
                endif
                depName = cc{2, k};
                outman('printf', o, '\t\t%s', depName);
                for kk = k : n
                    if ~flag(kk) && strcmp(depName, cc{2, kk})
                        outman('printf', o, '\t\t\tfunction %s', ...
                            cc{1, kk});
                        flag(kk) = true;
                        c{level, 1} = f;
                        c{level, 2} = kw;
                        c{level, 3} = t_b_p{k_t_b};
                        c{level, 4} = cc{1, kk};
                        c{level, 5} = depName;
                        outman('update_progress', o, p_id, level);
                        level = level + 1;
                    endif
                endfor
            endif
        endfor
    endfor

endfunction

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
    endif
    if any(strcmp(c, {'code', 'dependencies', 'encoding', 'all'}))
        outman('disconnect', oId);
    endif

    switch c

        case 'quit'
            clear_req = true;

        case 'configure'
            1;

        case {'code', 'dependencies', 'encoding', 'all'}
            varargout{1} = check_tree(s, cf, cargs, sM, c);

        otherwise
            error('Internal error: Command %s not handled', c);

    endswitch

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

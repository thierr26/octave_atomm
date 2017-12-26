## Copyright (C) 2016-2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function [clear_req, s, varargout] = run_command(c, cargs, cf, o, s1, nout, a)

    [s, startupRun] = build_outman_config_stru(s1, cf, o);

    clear_req = toolman_command(c, 'quit_command');

    if ~clear_req

        if startupRun
            oId = outman_connect_and_config_if_master(s.outman_config_stru);
            outman('logtimef', oId, '%s launched', a);
            log_dirs_err_if_non_existent('Top directory(ies):', cf.top)
            outman('disconnect', oId);
        endif

        switch c

            case 'configure'
                varargout{1} = cf;

            case 'get_config_origin'
                varargout{1} = o;

            otherwise
                s = build_read_dep_cache(s, cf, ...
                    toolman_command(c, 'refresh_cache_command'));

                if ~toolman_command(c, 'refresh_cache_command')
                    if toolman_command(c, 'run_test_command') ...
                            && ~isfield(s.read_dep, 'testcasetb')
                        s.read_dep = detect_test_cases(s.read_dep, ...
                            cf.test_case_tb_reg_exp, cf.test_case_reg_exp);
                    endif
                    if strcmp(c, 'run_all_tests')
                        ar = {s.read_dep.toolboxpath};
                    else
                        ar = cargs;
                    endif
                    depList = find_deps(s, ar, ...
                        toolman_command(c, 'run_test_command'));
                    if toolman_command(c, 'add_to_path_command')
                        addpath(strjoin(depList, pathsep));
                    endif
                    if toolman_command(c, 'run_test_command')
                        s = run_tests(depList, s);
                    endif
                    testFailure = report(depList, s, c, cargs, nout, a);
                    if toolman_command(c, 'run_test_command')
                        varargout{1} = ~testFailure;
                        if nout == 2
                            varargout{2} = depList;
                        endif
                    else
                        varargout{1} = depList;
                    endif
                endif

        endswitch

    endif

endfunction

# -----------------------------------------------------------------------------

# Build configuration structure for Outman.

function [s, startup_run] = build_outman_config_stru(s1, cf, o)

    s = s1;
    startup_run = ~isfield(s1, 'outman_config_stru');
    if startup_run
        s.outman_config_stru = strip_defaults_from_config_stru(...
            clean_up_struct(cf, fieldnames(outman_config_stru)), o);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Build the application cache, unless it has been already been and no refresh
# is required.

function s = build_read_dep_cache(s1, cf, refresh_required)

    s = s1;
    if ~isfield(s1, 'read_dep') || refresh_required
        oId = outman_connect_and_config_if_master(s.outman_config_stru);
        s.read_dep = read_declared_dependencies(find_m_toolboxes(cf.top));
        outman('disconnect', oId);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Locate the toolbox argument (or the current working directory if no argument
# has been provided) in the declared dependencies structure.

function ret = toolbox_argument_index(s, cargs)

    if numel(cargs) == 0
        curDir = pwd;
        oId = outman_connect_and_config_if_master(s.outman_config_stru);
        ret = toolbox_index(s.read_dep, curDir, 0, false, true);
        outman('disconnect', oId);
        if isempty(ret)
            error(['Current directory (%s) is not a toolbox in the source ' ...
                'tree. Perhaps you have forgotten to provide a toolbox ' ...
                'designation as argument.'], curDir);
        endif
    else
        oId = outman_connect_and_config_if_master(s.outman_config_stru);
        ret = toolbox_index(s.read_dep, cargs{1}, 0, true, true);
        outman('disconnect', oId);
        if isempty(ret)
            c = cell(2, cell_cum_numel(s.read_dep.mfiles));
            n = 0;
            nTb = numel(s.read_dep.toolboxpath);
            for kTb = 1 : nTb
                [flag, idx] = ismember(cargs{1}, s.read_dep.mfiles{kTb});
                if ~flag
                    if isempty(file_ext(cargs{1}))
                        for k = 1 : numel(s.read_dep.mfiles{kTb})
                            [~, name] = fileparts(s.read_dep.mfiles{kTb}{k});
                            if strcmp(cargs{1}, name)
                                flag = true;
                                idx = k;
                            endif
                        endfor
                    endif
                endif
                if flag
                    n = n + 1;
                    c{1, n} = fullfile(s.read_dep.toolboxpath{kTb}, ...
                        s.read_dep.mfiles{kTb}{idx});
                    c{2, n} = kTb;
                endif
            endfor
            c = c(:, 1 : n);
            if n > 1
                msg = sprintf(['%s is the name of a public M-file in ' ...
                    'multiple toolboxes:'], cargs{1});
                for k = 1 : n
                    msg = sprintf('%s\n%s', msg, c{1, k});
                endfor
                error(msg);
            elseif n == 0
                error(['%s is neither a toolbox nor an M-file in the ' ...
                    'source tree'], cargs{1});
            else
                ret = c{2, 1};
            endif
        elseif numel(ret) > 1
            error('Ambiguous toolbox designation: %s', cargs{1});
        endif
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Find the dependencies for the toolboxes or M-files provided in cmd_args cell
# array (or for the working directory if cmd_args is empty).

function c = find_deps(s, cmd_args, test_cases_included)

    v = zeros(1, numel(s.read_dep.toolboxpath));

    if numel(cmd_args) == 0 || ischar(cmd_args{1})
        v(1) = toolbox_argument_index(s, cmd_args);
        start = 1;
        finish = 1;
    else
        for k = 1 : numel(cmd_args{1})
            v(k) = toolbox_argument_index(s, cmd_args{1}(k));
        endfor
        start = 1;
        finish = numel(cmd_args{1});
    endif

    w = 0;
    while ~isempty(w)
        sliceLen = cell_cum_numel(s.read_dep.decl_dep(v(start : finish))) ...
            + numel(start : finish);
        w = zeros(1, sliceLen);
        lvl = 0;
        for k = start : finish
            deltaLvl = numel(s.read_dep.decl_dep{v(k)});
            declDep = [s.read_dep.decl_dep{v(k)} 0];
            if test_cases_included && s.read_dep.testcasetb(v(k)) ~= 0 ...
                    && ~ismember(s.read_dep.testcasetb(v(k)), ...
                        declDep(1 : end - 1))
                deltaLvl = deltaLvl + 1;
                declDep(end) = s.read_dep.testcasetb(v(k));
            endif
            w(lvl + 1 : lvl + deltaLvl) = declDep(1 : deltaLvl);
            lvl = lvl + deltaLvl;
        endfor
        w = unique(w(~ismember(w(1 : lvl), v)));
        start = finish + 1;
        finish = finish + numel(w);
        v(start : finish) = w;
    endwhile
    c = sort(s.read_dep.toolboxpath(v(1 : finish)));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Run tests.

function s = run_tests(tb, s1)

    s = s1;
    s.test_cases_results = struct([]);
    n = numel(tb);
    testCaseCount = 0;
    testCaseErrorCount = 0;
    s.erroring_test_case = zeros(cell_cum_numel(s.read_dep.mfiles), 3);
    oId = outman_connect_and_config_if_master(s.outman_config_stru);
    outman('logtimef', oId, 'Start running the test cases');
    pId = outman('init_progress', oId, 0, n, 'Running the test cases...');
    for k = 1 : n
        [~, idx] = ismember(tb{k}, s.read_dep.toolboxpath);
        v = s.read_dep.testcases{idx};
        if ~isempty(v)
            for kk = v
                [~, testCaseFuncName] = fileparts(s.read_dep.mfiles{idx}{kk});
                expr = [testCaseFuncName '()'];
                err = false;
                try
                    ss = eval(expr);
                catch
                    outman('errorf', oId, '%s has issued an error', expr);
                    err = true;
                end_try_catch
                if ~err && ~isstruct(ss)
                    outman('errorf', oId, ...
                        '%s has not returned a structure', expr);
                    err = true;
                endif
                if ~err
                    [fN, fC] = field_names_and_count(ss);
                    if fC == 0
                        outman('errorf', oId, ...
                            '%s has returned an empty structure', expr);
                        err = true;
                    elseif fC > 1
                        outman('errorf', oId, ['%s has returned a ' ...
                            'structure with more than one field'], expr);
                        err = true;
                    else
                        fN = fN{1};
                    endif
                endif
                if ~err
                    testCaseCount = testCaseCount + 1;
                    if testCaseCount == 1
                        s.test_cases_results = ss;
                    else
                        f = fieldnames(s.test_cases_results);
                        if ~ismember(fN, f)
                            s.test_cases_results.(fN) = ss.(fN);
                        else
                            kkk = 1;
                            while ismember([fN '_' num2str(kkk)], f)
                                kkk = kkk + 1;
                            endwhile
                            outman('infof', oId, ['%s has returned a ' ...
                                'structure with field %s (test case ' ...
                                'name) but another test case has used ' ...
                                'this name.'], expr, fN);
                            s.test_cases_results.([fN '_' num2str(kkk)]) ...
                                = ss.(fN);
                        endif
                    endif
                endif
                if err
                    testCaseErrorCount = testCaseErrorCount + 1;
                    s.erroring_test_case(testCaseErrorCount, :) = [k idx kk];
                endif
            endfor
        endif
        outman('update_progress', oId, pId, k);
    endfor
    s.erroring_test_case = s.erroring_test_case(1 : testCaseErrorCount, :);
    s.test_duration = outman('terminate_progress', oId, pId);
    outman('logtimef', oId, 'Done running the test cases\n');
    outman('disconnect', oId);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Output a report to the log file and (if required) to the command line. The
# output argument is always false except if test cases have been run
# unsuccessfully.

function test_failure = report(tb, s, cmd, cmd_args, nout, appname)

    test_failure = false;
    cmdWinOutput = ~toolman_command(cmd, 'refresh_cache_command') ...
        && (toolman_command(cmd, 'verbose_command') ...
        || ((nout == 0 ...
        || (nout == 1 && toolman_command(cmd, 'run_test_command'))) ...
        && toolman_command(cmd, 'auto_verbose_command')));

    if numel(cmd_args) == 0
        ar = sprintf('''%s''', pwd);
    elseif ischar(cmd_args{1})
        ar = sprintf('''%s''', cmd_args{1});
    else
        ar = list_string(cmd_args{1}, ', ', '''', '''', '{', '}');
    endif

    if toolman_command(cmd, 'add_to_path_command')
        if strcmp(cmd, 'run_all_tests')
            opening = {'%s(''%s'') %s:', appname, cmd};
        else
            opening = {'%s(''%s'', %s) %s:', appname, cmd, ar};
        endif
        opening = [opening {'has added to the path'}];
        closing = {''};
        if cmdWinOutput
            outmanCmdOpenClose = 'printf';
        else
            outmanCmdOpenClose = 'logf';
        endif
        outmanCmdPath = outmanCmdOpenClose;
    else
        opening = {'%s(''%s'', %s) %s:', appname, cmd, ar, 'output'};
        closing = {'End of %s(''%s'', %s) output\n', appname, cmd, ar};
        outmanCmdOpenClose = 'logf';
        outmanCmdPath = outmanCmdOpenClose;
        if cmdWinOutput
            outmanCmdPath = 'printf';
        endif
    endif

    oId = outman_connect_and_config_if_master(s.outman_config_stru);
    outman(outmanCmdOpenClose, oId, opening{:});
    cellfun(@(x) outman(outmanCmdPath, oId, '%s', x), tb);
    outman(outmanCmdOpenClose, oId, closing{:});
    if toolman_command(cmd, 'run_test_command')
        passedFailed = report_test_rslt(s.test_cases_results, ~cmdWinOutput);
        test_failure = passedFailed(2) ~= 0 || ~isempty(s.erroring_test_case);
        if ~isempty(s.erroring_test_case)
            n = size(s.erroring_test_case, 1);
            fmtStr = ['The following test cases could not be run or their ' ...
                'result could not be taken into account:' ...
                repmat('\n  %s', 1, n)];
            argV = cell(1, n);
            for k = 1 : n
                k2 = s.erroring_test_case(k, 2);
                k3 = s.erroring_test_case(k, 3);
                argV{k} = fullfile(tb{s.erroring_test_case(k, 1)}, ...
                    s.read_dep.mfiles{k2}{k3});
            endfor
            outman('errorf', oId, fmtStr, argV{:});
        endif
        outman(outmanCmdOpenClose, oId, ...
            'Running the test cases took %s\n', ...
            duration_str(s.test_duration));
    endif
    outman('disconnect', oId);

endfunction

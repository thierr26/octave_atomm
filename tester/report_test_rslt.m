## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} report_test_rslt (@var{s})
## @deftypefnx {Function File} report_test_rslt (@var{s}, @var{@
## write_to_log_file_only})
##
## Output test case results.
##
## @var{s} is a structure as returned by @code{run_test_case}, except it may
## have multiple fields and thus contain the results for more than one test
## case.
##
## @code{report_test_rslt} outputs the results for the test cases using
## @code{outman}, more precisely using Outman's "printf" command, unless the
## input argument @var{write_to_log_file_only} is provided and set to true.
##
## @code{report_test_rslt} also returns a row vector of length 2.  The first
## component of the vector is the total number of passed test routines.  The
## second component of the vector is the total number of failed test routines.
##
## @seealso{outman, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = report_test_rslt(s, varargin)

    [testCase, testCaseCount] = field_names_and_count(s);
    write_to_log_file_only ...
        = validated_opt_args({@is_logical_scalar, false}, varargin{:});
    if write_to_log_file_only
        oCmd = 'logf';
    else
        oCmd = 'printf';
    endif

    oId = outman_connect_and_config_if_master;

    ret = zeros(1, 2);
    for tC = 1 : testCaseCount
        tCN = testCase{tC};
        if isfield(s.(tCN), 'test')
            [routine, routineCount] = field_names_and_count(s.(tCN).test);
            passedCount = 0;
            failedCount = 0;
            failedIdx = zeros(1, routineCount);
            for r = 1 : routineCount
                rName = routine{r};
                if ~isfield(s.(tCN).test.(rName), 'passed') ...
                        || ~is_logical_scalar(s.(tCN).test.(rName).passed) ...
                        || ~isfield(s.(tCN).test.(rName), 'failure_cause') ...
                        || ~is_string(s.(tCN).test.(rName).failure_cause)
                    outman('errorf', oId, ['Test routine %s in test case ' ...
                        '%s: Invalid result structure'], rName, tCN);
                else
                    if s.(tCN).test.(rName).passed
                        passedCount = passedCount + 1;
                    else
                        failedCount = failedCount + 1;
                        failedIdx(failedCount) = r;
                    endif
                endif
            endfor
            failedIdx = failedIdx(1 : failedCount);
            ret = ret + [passedCount failedCount];
            outman(oCmd, oId, ['%s test case: %d test routines (%d ' ...
                'passed, %d failed)'], ...
                tCN, passedCount + failedCount, passedCount, failedCount);
            for r = failedIdx
                rName = routine{r};
                outman(oCmd, oId, '\tTest routine %s failed: %s', ...
                    rName, s.(tCN).test.(rName).failure_cause);
            endfor
        endif
    endfor

    if testCaseCount > 1
        outman(oCmd, oId, 'Total: %d test routines (%d passed, %d failed)', ...
            sum(ret), ret(1), ret(2));
    endif

    outman('disconnect', oId);

endfunction

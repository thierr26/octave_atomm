## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} report_test_rslt (@var{s})
##
## Output test case results.
##
## @var{s} is a structure as returned by @code{run_test_case}, except it may
## have multiple fields and thus contain the results for more than one test
## case.
##
## @code{report_test_rslt} outputs the results for the test cases using
## application @code{outman}.
##
## @seealso{outman, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function report_test_rslt(s)

    [testCase, testCaseCount] = field_names_and_count(s);

    oId = outman_connect_and_config_if_master;

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
            outman('printf', oId, ['%s test case: %d test routines (%d ' ...
                'passed, %d failed)'], ...
                tCN, passedCount + failedCount, passedCount, failedCount);
            for r = failedIdx
                rName = routine{r};
                outman('printf', oId, '\tTest routine %s failed: %s', ...
                    rName, s.(tCN).test.(rName).failure_cause);
            endfor
        endif
    endfor

    outman('disconnect', oId);

endfunction

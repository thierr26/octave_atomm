## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{passed_failed} =} report_test_rslt (@var{@
## s})
## @deftypefnx {Function File} {@var{passed_failed} =} report_test_rslt (@var{@
## s}, @var{write_to_log_file_only})
##
## Output a human readable report for test case results.
##
## @code{@var{passed_failed} = report_test_rslt (@var{s})} outputs a human
## readable report for test results.  @var{s} is the kind of structure that
## function @code{run_test_case} reports, except that it can have more than one
## field and thus contain the results of multiple test cases.  Please run
## @code{help run_test_case} to get a full description of the fields of
## @var{s}.
##
## In the Atomm source tree, all the functions having a name starting with
## "test_" (for example @code{test_structure} in the structure/test_case
## subdirectory) return structures that can be provided as argument to function
## @code{report_test_rslt}.
##
## @example
## @group
## @var{passed_failed} = report_test_rslt (test_structure);
## @end group
## @end example
##
## The returned value @var{passed_failed} is a row vector of length 2.  The
## first component of the vector is the total number of passed tests.  The
## second component of the vector is the total number of failed tests.
##
## The optional argument @var{write_to_log_file_only} is useful to control the
## output.  It is a logical scalar and defaults to false.  To understand its
## role, one have to be aware that @code{report_test_rslt} uses Outman (the
## output manager provided in the Atomm source tree) for its output.  Precisely
## it uses the following Outman commands:
##
## @table @asis
## @item @qcode{"errorf"}
## To output an error message to the HMI and to the log file (if Outman's
## master caller has set up a log file) if @var{s} is not valid as an input
## argument.
##
## @item @qcode{"printf"} or @qcode{"logf"} to output the human readable report
## The former if @var{write_to_log_file_only} is false, the latter otherwise.
## @end table
##
## Outman command @qcode{"printf"} outputs to both the HMI and the log file (if
## Outman's master caller has set up a log file).  Outman command
## @qcode{"logf"} outputs to the log file only.  So
## @var{write_to_log_file_only} must be set to true when no output to the HMI
## is desired.  Please run @code{help outman} for more information about
## Outman.
##
## @seealso{outman, run_test_case, test_structure}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function passed_failed = report_test_rslt(s, varargin)

    [testCase, testCaseCount] = field_names_and_count(s);
    write_to_log_file_only ...
        = validated_opt_args({@is_logical_scalar, false}, varargin{:});
    if write_to_log_file_only
        oCmd = 'logf';
    else
        oCmd = 'printf';
    endif

    oId = outman_connect_and_config_if_master;

    passed_failed = zeros(1, 2);
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
            passed_failed = passed_failed + [passedCount failedCount];
            outman(oCmd, oId, ['%s test case: %d test routines (%d ' ...
                'passed, %d failed)'], ...
                tCN, passedCount + failedCount, passedCount, failedCount);
            for r = failedIdx
                rName = routine{r};
                outman(oCmd, oId, '  Test routine %s failed: %s', ...
                    rName, s.(tCN).test.(rName).failure_cause);
            endfor
        endif
    endfor

    if testCaseCount > 1
        outman(oCmd, oId, 'Total: %d test routines (%d passed, %d failed)', ...
            sum(passed_failed), passed_failed(1), passed_failed(2));
    endif

    outman('disconnect', oId);

endfunction

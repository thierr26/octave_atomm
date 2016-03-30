## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} run_test_case (@var{name}, @var{test_routine})
##
## Run a test case.
##
## @var{name} is the name of the test case (arbitrary non empty string) and
## @var{test_routine} is a cell array of function handles.  The functions
## pointed to by the handles are the test routines in the test case.
##
## A test routine is a function with no output argument (which means that the
## expected behavior of the test routine is to raise an error) or with one
## logical output argument (which means that the expected behavior of the test
## routine is to return true).
##
## @code{run_test_case} runs the test routines, and builds a return structure.
## This structure has exactly one field named after the test case (@var{name}).
## This field contains a structure with a field called "duration" (how much
## wall clock time it took to run all the test routines) and a field called
## "test" which is a structure with one field for each test routine and these
## fields are themselves structures with the following fields:
##
## @table @asis
## @item passed
## true if the test routine behaved as expected, false otherwise.
##
## @item failure_cause
## Empty string if the test routine has behaved as expected, otherwise one of
## the following strings:
##
## @itemize @bullet
##
## @item
## "Wrong result" if the test routine returned false.
##
## @item
## "Error raised" if the test routine unexpectedly raised an error.
##
## @item
## "No error raised" if the test routine did not raise an error whereas it was
## expected to.
##
## @item
## "Invalid test routine" if the test routine has more than one output
## argument.
##
## @item
## "Not run" if the test routine has not been run.
## @end itemize
## @end table
##
## @seealso{report_test_rslt}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = run_test_case(name, test_routine)

    validated_mandatory_args(...
        {@is_non_empty_string, @is_cell_array_of_func_handle}, ...
        name, test_routine);

    n = numel(test_routine);

    oId = outman_connect_and_config_if_master;
    pId = outman('init_progress', oId, 0, max([1 n]), name);

    routName = cellfun(@func2str, test_routine, 'UniformOutput', false);

    s = struct(name, struct('duration', -1, 'test', struct()));
    for k = 1 : n
        if isfield(s.(name).test, routName{k})
            error('Test routine %s appears more than once', routName{k});
        endif
        s.(name).test.(routName{k}) = struct(...
            'passed', false, 'failure_cause', 'Not run');
    endfor

    # Loop over the test routines.
    for k = 1 : n

        try
            nAO = nargout(test_routine{k});
        catch
            error(['%s is probably a built-in function, built-in ' ...
                'functions are not allowed as test routines'], routName{k});
        end_try_catch

        if nAO == 0
            # The current test test_routine is expected to throw an error.

            try
                test_routine{k}();
                s.(name).test.(routName{k}).failure_cause = ...
                    'No error raised';
            catch
                s.(name).test.(routName{k}).passed = true;
                s.(name).test.(routName{k}).failure_cause = '';
            end_try_catch
        elseif nAO == 1
            # The current test test_routine is not expected to throw an error.

            try
                r = test_routine{k}();

                if isscalar(r) && islogical(r)
                    s.(name).test.(routName{k}).passed = r;
                    if ~r
                        s.(name).test.(routName{k}).failure_cause ...
                            = 'Wrong result';
                    else
                        s.(name).test.(routName{k}).failure_cause = '';
                    endif
                else
                    s.(name).test.(routName{k}).failure_cause ...
                        = 'Non scalar or non logical return value';
                endif
            catch
                s.(name).test.(routName{k}).failure_cause = 'Error raised';
            end_try_catch

        else
            # The current test routine is not a valid test routine.

            s.(name).test.(routName{k}).failure_cause = ...
                'Invalid test routine';
        endif
        outman('update_progress', oId, pId, k);
    endfor

    s.(name).duration = outman('terminate_progress', oId, pId);
    outman('disconnect', oId);

endfunction

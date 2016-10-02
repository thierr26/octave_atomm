## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} run_test_case (@var{@
## test_case_name}, @var{test_routine})
##
## Run a test case and return the results as a structure.
##
## In this context, a test case is a list of test routines provided in the
## @var{test_routine} argument as a cell array of function handles.  The
## functions pointed to by the handles are the test routines.  There must be no
## duplicates in the array.
##
## The test routines must fulfill the following conditions:
##
## @itemize @bullet
## @item
## Be callable without any input argument.
##
## @item
## Be a valid input argument for function @code{nargout}@footnote{User defined
## functions are all valid input arguments for function @code{nargout} but
## built-in functions may not be.  Depending on the interpreter (Octave or
## Matlab) and its version, calling @code{nargout} with a built-in function as
## argument may issue an error.  For example, with Octave 4.0.3 both
## @code{nargout("isempty")} and @code{nargout(@@isempty)} issue an error.}.
##
## @item
## Have no or one output argument.
## @end itemize
##
## A test routine having no output argument is expected to issue an error.  A
## call to such a test routine that would not issue an error is considered a
## test failure by function @code{run_test_case}.  Conversely, A call to such
## a test routine that issues an error is considered a passed test.
##
## A test routine having one output argument is expected to return true
## (logical scalar value).  A call to such a test routine that would return
## anything else is considered a test failure by function @code{run_test_case}.
## This includes:
##
## @itemize @bullet
## @item
## Returning a false logical scalar value.
##
## @item
## Returning a non logical or non scalar value.
##
## @item
## Issuing an error.
## @end itemize
##
## The action of @code{@var{s} = run_test_case (@var{test_case_name}, @var{@
## test_routine})} is to attempt to run all the test routines and return a
## structure @var{s} which serves as a test report.  This structure contains
## one field.  The name of this field is the test case name provided in the
## @var{test_case_name} argument.  Of course, this implies that
## @var{test_case_name} is a valid field name, as determined by function
## @code{is_identifier}.
##
## @code{@var{s}.(@var{test_case_name})} is itself a structure, containing the
## following fields:
##
## @table @asis
## @item duration
## How much wall clock time (in days) it took to run all the test routines.
##
## @item test
## A structure containing one field for every test routine.  The fields have
## the names of the test routines.
## @end table
##
## The fields of @code{@var{s}.(@var{test_case_name}).test} are themselves
## structures with the following fields:
##
## @table @asis
## @item passed
## true for a passed test, false otherwise.
##
## @item failure_cause
## Empty string for a passed test, otherwise one of the following strings:
##
## @itemize @bullet
## @item
## "Non scalar or non logical return value" for a test routine that did not
## return a logical scalar value (applicable to test routines with an output
## argument).
##
## @item
## "Wrong result" for a test routine that returned false (applicable to test
## routines with an output argument).
##
## @item
## "Error issued" for a test routine that unexpectedly issued an error
## (applicable to test routines with an output argument).
##
## @item
## "No error issued" for a test routine that did not issue an error whereas it
## was expected to (applicable to test routines without output argument).
##
## @item
## "Invalid test routine" for a test routine that has more than one output
## argument.
## @end itemize
## @end table
##
## Examples of usage of @code{run_test_case} can be found in the Atomm
## source tree.  All the functions having a name starting with "test_" (for
## instance @code{test_structure} in the structure/test_case subdirectory) call
## @code{run_test_case} and return its return structure as is.
##
## The structure returned by @code{run_test_case} can be provided as an
## argument to function @code{report_test_rslt} which outputs it as a human
## readable report.  Example:
##
## @example
## @group
## report_test_rslt (test_structure);
## @end group
## @end example
##
## Both @code{run_test_case} and @code{report_test_rslt} use Outman (the output
## manager provided in the Atomm source tree) for their output (information
## messages, error messages, progress indication, @dots{}).  Please run
## @code{help outman} for more information about Outman.
##
## Note that there is an alternative way of running test cases, which is to use
## Toolman (the toolbox manager provided in the Atomm source tree).  For
## example, the following command runs the test case (function
## @code{test_structure}) for toolbox "structure".  Just adjust the path to the
## Atomm source tree.  The command also runs the test cases of all the
## toolboxes that are dependencies for toolbox "structure" assuming the
## dependency files are present and correct in the Atomm source tree.
##
## @example
## @group
## toolman ('run_test', 'structure', '--', 'top', 'path/to/atomm');
## @end group
## @end example
##
## Please run @code{help toolman} for more information about Toolman.
##
## @seealso{is_identifier, nargout, outman, report_test_rslt, test_structure,
## toolman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = run_test_case(test_case_name, test_routine)

    validated_mandatory_args(...
        {@is_identifier, @is_cell_array_of_func_handle}, ...
        test_case_name, test_routine);

    n = numel(test_routine);

    oId = outman_connect_and_config_if_master;
    pId = outman('init_progress', oId, 0, max([1 n]), ...
        ['Running ' test_case_name '...']);

    routName = cellfun(@func2str, test_routine, 'UniformOutput', false);

    s = struct(test_case_name, struct('duration', -1, 'test', struct()));
    for k = 1 : n
        if isfield(s.(test_case_name).test, routName{k})
            error(['Test routine %s appears more than once in the test ' ...
                'routines list'], routName{k});
        endif
        s.(test_case_name).test.(routName{k}) = struct(...
            'passed', false, 'failure_cause', 'Not run');
    endfor

    # Loop over the test routines.
    for k = 1 : n

        try
            nAO = nargout(test_routine{k});
        catch
            error(['nargout(''%s'') issues an error, probably because %s ' ...
                'is a built-in function. Test routines should rather be ' ...
                'user defined functions.'], routName{k}, routName{k});
        end_try_catch

        if nAO == 0
            # The current test routine is expected to issue an error.

            try
                test_routine{k}();
                s.(test_case_name).test.(routName{k}).failure_cause = ...
                    'No error issued';
            catch
                s.(test_case_name).test.(routName{k}).passed = true;
                s.(test_case_name).test.(routName{k}).failure_cause = '';
            end_try_catch
        elseif nAO == 1
            # The current test routine is not expected to issue an error.

            try
                r = test_routine{k}();

                if isscalar(r) && islogical(r)
                    s.(test_case_name).test.(routName{k}).passed = r;
                    if ~r
                        s.(test_case_name).test.(routName{k}).failure_cause ...
                            = 'Wrong result';
                    else
                        s.(test_case_name).test.(routName{k}).failure_cause ...
                            = '';
                    endif
                else
                    s.(test_case_name).test.(routName{k}).failure_cause ...
                        = 'Non scalar or non logical return value';
                endif
            catch
                s.(test_case_name).test.(routName{k}).failure_cause ...
                    = 'Error issued';
            end_try_catch

        else
            # The current test routine is not a valid test routine.

            s.(test_case_name).test.(routName{k}).failure_cause = ...
                'Invalid test routine';
        endif
        outman('update_progress', oId, pId, k);
    endfor

    s.(test_case_name).duration = outman('terminate_progress', oId, pId);
    outman('disconnect', oId);

endfunction

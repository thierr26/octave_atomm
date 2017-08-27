## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_lib_checkmtree ()
##
## Run test case for toolbox "lib_checkmtree", return results as a structure.
##
## @code{@var{s} = test_lib_checkmtree ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_lib_checkmtree" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "lib_checkmtree".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_lib_checkmtree

    # Declare the test routines.
    testRoutine = {...
        @find_m_toolboxes_no_error, ...
        @string_or_cellstr_arg_or_none_string, ...
        @string_or_cellstr_arg_or_none_cellstr, ...
        @string_or_cellstr_arg_or_none_none, ...
        @string_or_cellstr_arg_or_none_other, ...
        @string_or_cellstr_arg_or_none_opt_logical_string, ...
        @string_or_cellstr_arg_or_none_opt_logical_cellstr, ...
        @string_or_cellstr_arg_or_none_opt_logical_none, ...
        @string_or_cellstr_arg_or_none_opt_logical_other, ...
        @string_or_cellstr_arg_or_none_opt_logical_string_opt, ...
        @string_or_cellstr_arg_or_none_opt_logical_cellstr_opt, ...
        @string_or_cellstr_arg_or_none_opt_logical_none_opt, ...
        @string_or_cellstr_arg_or_none_opt_logical_string_other};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function ret = find_m_toolboxes_no_error

    find_m_toolboxes(atomm_root);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_string

    ret = string_or_cellstr_arg_or_none('abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_cellstr

    ret = string_or_cellstr_arg_or_none({'abc', 'def'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_none

    ret = string_or_cellstr_arg_or_none;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_other

    ret = ~string_or_cellstr_arg_or_none(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_opt_logical_string

    ret = string_or_cellstr_arg_or_none_opt_logical('abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_opt_logical_cellstr

    ret = string_or_cellstr_arg_or_none_opt_logical({'abc', 'def'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_opt_logical_none

    ret = string_or_cellstr_arg_or_none_opt_logical;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_opt_logical_other

    ret = ~string_or_cellstr_arg_or_none_opt_logical(1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_opt_logical_string_opt

    ret = string_or_cellstr_arg_or_none_opt_logical('abc', true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_opt_logical_cellstr_opt

    ret = string_or_cellstr_arg_or_none_opt_logical({'abc', 'def'}, true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_opt_logical_none_opt

    ret = string_or_cellstr_arg_or_none_opt_logical(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_or_cellstr_arg_or_none_opt_logical_string_other

    ret = ~string_or_cellstr_arg_or_none_opt_logical('abc', 1);

endfunction

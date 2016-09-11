## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_lib_toolman ()
##
## Run test case for toolbox "lib_toolman", return results as a structure.
##
## @code{@var{s} = test_lib_toolman ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_lib_toolman" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "lib_toolman".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_lib_toolman

    # Declare the test routines.
    testRoutine = {...
        @string_arg_or_none_string, ...
        @string_arg_or_none_cellstr, ...
        @string_arg_or_none_none, ...
        @string_arg_or_none_other};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function ret = string_arg_or_none_string

    ret = string_arg_or_none('abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_arg_or_none_cellstr

    ret = ~string_arg_or_none({'abc', 'def'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_arg_or_none_none

    ret = string_arg_or_none;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = string_arg_or_none_other

    ret = ~string_arg_or_none(true);

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_lib_toolman ()
##
## Test the lib_toolman toolbox.
##
## @code{test_lib_toolman} tests the lib_toolman toolbox and returns a
## structure.
##
## This structure is a structure returned by @code{run_test_case} and can be
## used as argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
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

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_env ()
##
## Run test case for toolbox "env", return results as a structure.
##
## @code{@var{s} = test_env ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_env" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "env".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_env

    # Declare the test routines.
    testRoutine = {...
        @fullmfilename_ok, ...
        @backspace_supported_no_error, ...
        @home_dir_non_empty_string, ...
        @more_is_on_no_error, ...
        @command_window_width_no_error, ...
        @is_octave_no_error, ...
        @host_name_no_error};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function ret = fullmfilename_ok

    ret = isequal(fullmfilename, ...
        [atomm_root filesep 'env' filesep 'test_case' filesep 'test_env.m']);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = backspace_supported_no_error

    ret = backspace_supported || true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = home_dir_non_empty_string

    ret = is_non_empty_string(home_dir);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = more_is_on_no_error

    ret = more_is_on || true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_window_width_no_error

    w = command_window_width;
    ret = is_integer_scalar(w) && w >= -1;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_octave_no_error

    ret = is_octave || true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = host_name_no_error

    host_name;
    ret = true;

endfunction


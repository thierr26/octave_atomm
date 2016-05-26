## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_env ()
##
## Test the env toolbox.
##
## @code{test_env} tests the env toolbox and returns a structure.  This
## structure is a structure returned by @code{run_test_case} and can be used as
## argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
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
        @is_octave_no_error};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function str = atomm_dir

    str = mfilename('fullpath');
    name = '';
    while ~strcmp(name, 'atomm')
        [str, name] = fileparts(str);
    endwhile
    str = fullfile(str, name);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = fullmfilename_ok

    ret = isequal(fullmfilename, ...
        [atomm_dir filesep 'env' filesep 'test' filesep 'test_env.m']);

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

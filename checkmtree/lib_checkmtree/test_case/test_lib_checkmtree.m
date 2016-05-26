## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_lib_checkmtree ()
##
## Test the lib_checkmtree toolbox.
##
## @code{test_lib_checkmtree} tests the lib_checkmtree toolbox and returns a
## structure.
##
## This structure is a structure returned by @code{run_test_case} and can be
## used as argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_lib_checkmtree

    # Declare the test routines.
    testRoutine = {...
        @find_m_toolboxes_no_error, ...
        @find_m_toolboxes_ignore_p_no_error, ...
        @string_or_cellstr_arg_or_none_string, ...
        @string_or_cellstr_arg_or_none_cellstr, ...
        @string_or_cellstr_arg_or_none_none, ...
        @string_or_cellstr_arg_or_none_other};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function str = atomm_dir

    str = fullmfilename;
    name = '';
    while ~strcmp(name, 'atomm')
        [str, name] = fileparts(str);
    endwhile
    str = fullfile(str, name);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = find_m_toolboxes_no_error

    find_m_toolboxes(atomm_dir);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = find_m_toolboxes_ignore_p_no_error

    find_m_toolboxes(atomm_dir, true);
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

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_lib_outman ()
##
## Run test case for toolbox "lib_outman", return results as a structure.
##
## @code{@var{s} = test_lib_outman ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_lib_outman" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "lib_outman".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_lib_outman

    # Declare the test routines.
    testRoutine = {...
        @outman_is_valid_progress_format_fail_wrong_arg_type, ...
        @outman_is_valid_progress_format_no_spec, ...
        @outman_is_valid_progress_format_s_spec, ...
        @outman_is_valid_progress_format_d_spec, ...
        @outman_is_valid_progress_format_s_d_spec, ...
        @outman_is_valid_progress_format_d_s_spec, ...
        @outman_is_valid_progress_format_wrong_arg_1, ...
        @outman_is_valid_progress_format_wrong_arg_2, ...
        @outman_is_valid_progress_format_wrong_arg_3, ...
        @outman_progress_indicator_length_no_spec, ...
        @outman_progress_indicator_length_s, ...
        @outman_progress_indicator_length_d, ...
        @outman_progress_indicator_length_s_d, ...
        @outman_progress_indicator_length_d_s, ...
        @first_str_arg_pos_0_0, ...
        @first_str_arg_pos_1_0, ...
        @first_str_arg_pos_2_0, ...
        @first_str_arg_pos_1_1, ...
        @first_str_arg_pos_2_1, ...
        @first_str_arg_pos_2_2, ...
        @outman_progress_string_no_spec_0, ...
        @outman_progress_string_no_spec_1, ...
        @outman_progress_string_no_spec_2, ...
        @outman_progress_string_s, ...
        @outman_progress_string_d, ...
        @outman_progress_string_s_d, ...
        @outman_progress_string_d_s};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function outman_is_valid_progress_format_fail_wrong_arg_type

    outman_is_valid_progress_format(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_is_valid_progress_format_no_spec

    str = 'abc';
    [r, fmt, ord] = outman_is_valid_progress_format('abc');
    ret = r && isequal(fmt, str) && isequal(ord, []);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_is_valid_progress_format_s_spec

    [r, fmt, ord] = outman_is_valid_progress_format('[ %msg ]');
    ret = r && isequal(fmt, '[ %s ]') && isequal(ord, 1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_is_valid_progress_format_d_spec

    [r, fmt, ord] = outman_is_valid_progress_format('[ %percent%% ]');
    ret = r && isequal(fmt, '[ %3d%% ]') && isequal(ord, 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_is_valid_progress_format_s_d_spec

    [r, fmt, ord] = outman_is_valid_progress_format('[ %msg %percent%% ]');
    ret = r && isequal(fmt, '[ %s %3d%% ]') && isequal(ord, [1 2]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_is_valid_progress_format_d_s_spec

    [r, fmt, ord] = outman_is_valid_progress_format('[ %percent%% %msg ]');
    ret = r && isequal(fmt, '[ %3d%% %s ]') && isequal(ord, [2 1]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_is_valid_progress_format_wrong_arg_1

    ret = ~outman_is_valid_progress_format('[ %percent%%% ]');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_is_valid_progress_format_wrong_arg_2

    ret = ~outman_is_valid_progress_format('[ %percent%% %percent ]');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_is_valid_progress_format_wrong_arg_3

    ret = ~outman_is_valid_progress_format('[ %msg %percent%%% %msg ]');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_indicator_length_no_spec

    ret = outman_progress_indicator_length('Test', 'abc', []) == 3;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_indicator_length_s

    ret = outman_progress_indicator_length('Test', '[ %s ]', 1) == 8;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_indicator_length_d

    ret = outman_progress_indicator_length('Test', '[ %3d%% ]', 2) == 8;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_indicator_length_s_d

    ret = outman_progress_indicator_length('Test', ...
        '[ %s %3d%% ]', [1 2]) == 13;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_indicator_length_d_s

    ret = outman_progress_indicator_length('Test', ...
        '[ %3d%% %s ]', [2 1]) == 13;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = first_str_arg_pos_0_0

    ret = first_str_arg_pos == 0;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = first_str_arg_pos_1_0

    ret = first_str_arg_pos(0) == 0;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = first_str_arg_pos_2_0

    ret = first_str_arg_pos(0, true) == 0;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = first_str_arg_pos_1_1

    ret = first_str_arg_pos('abc') == 1;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = first_str_arg_pos_2_1

    ret = first_str_arg_pos('abc', true) == 1;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = first_str_arg_pos_2_2

    ret = first_str_arg_pos(0, 'abc') == 2;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_string_no_spec_0

    dura_str = '1 day, 5 hours, 37 minutes and 46 seconds';
    ret = strcmp(outman_progress_string({}, [], 'abc', [], dura_str), ...
        ' 1 day, 5 hours, 37 minutes and 46 seconds');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_string_no_spec_1

    dura_str = '1 day, 5 hours, 37 minutes and 46 seconds';
    ret = strcmp(outman_progress_string({'Test'}, 0, 'abc', [], dura_str), ...
        'abc 1 day, 5 hours, 37 minutes and 46 seconds');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_string_no_spec_2

    dura_str = '1 day, 5 hours, 37 minutes and 46 seconds';
    ret = strcmp(outman_progress_string({'first', 'second'}, [1 5], 'abc', ...
        [], dura_str), 'abcabc 1 day, 5 hours, 37 minutes and 46 seconds');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_string_s

    dura_str = '1 day, 5 hours, 37 minutes and 46 seconds';
    ret = strcmp(outman_progress_string({'first', 'second'}, [1 50], ...
        '[ %s ]', 1, dura_str), ...
        '[ first ][ second ] 1 day, 5 hours, 37 minutes and 46 seconds');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_string_d

    dura_str = '1 day, 5 hours, 37 minutes and 46 seconds';
    ret = strcmp(outman_progress_string({'first', 'second'}, [1 50], ...
        '[ %3d%% ]', 2, dura_str), ...
        '[   1% ][  50% ] 1 day, 5 hours, 37 minutes and 46 seconds');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_string_s_d

    dura_str = '1 day, 5 hours, 37 minutes and 46 seconds';
    ret = strcmp(outman_progress_string({'first', 'second'}, [1 50], ...
        '[ %s %3d%% ]', [1 2], dura_str), ...
        ['[ first   1% ][ second  50% ] 1 day, 5 hours, 37 minutes and 46 ' ...
        'seconds']);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_progress_string_d_s

    ret = strcmp(outman_progress_string({'first', 'second'}, [1 100], ...
        '[ %3d%% %s ]', [2 1], ''), '[   1% first ][ 100% second ]');

endfunction

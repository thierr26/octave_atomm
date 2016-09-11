## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_datetime ()
##
## Run test case for toolbox "datetime", return results as a structure.
##
## @code{@var{s} = test_datetime ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_datetime" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "datetime".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_datetime

    # Declare the test routines.
    testRoutine = {...
        @duration_str_fail_invalid_dura, ...
        @duration_str_fail_invalid_s_1, ...
        @duration_str_fail_invalid_s_2, ...
        @duration_str_0d, ...
        @duration_str_1d, ...
        @duration_str_1d_1h, ...
        @duration_str_1d_1h_1m, ...
        @duration_str_1d_1h_1m_1s, ...
        @duration_str_1h_1m_1s, ...
        @duration_str_1m_1s, ...
        @duration_str_1s, ...
        @duration_str_1d_1m_1s, ...
        @duration_str_1d_1h_1s, ...
        @duration_str_1d_1s, ...
        @duration_str_1h_1m, ...
        @duration_str_1h, ...
        @duration_str_1m, ...
        @duration_str_2d_1h_1m_1s, ...
        @duration_str_1d_2h_1m_1s, ...
        @duration_str_1d_1h_2m_1s, ...
        @duration_str_1d_1h_1m_2s, ...
        @duration_str_negative, ...
        @duration_str_s, ...
        @duration_str_1p98s, ...
        @timestamp_fail_wrong_type, ...
        @timestamp_fail_column, ...
        @timestamp_fail_numel, ...
        @timestamp_no_arg_no_error, ...
        @timestamp_scalar, ...
        @timestamp_vector, ...
        @timestamp2filename_fail_wrong_type, ...
        @timestamp2filename_empty_string, ...
        @timestamp2filename_fail_empty_cell_array, ...
        @timestamp2filename_str, ...
        @timestamp2filename_cellstr, ...
        @timestamp2filename_char, ...
        @timestamp2datenum_fail_wrong_type, ...
        @timestamp2datenum_fail_empty_string, ...
        @timestamp2datenum_fail_empty_cell_array, ...
        @timestamp2datenum_str, ...
        @timestamp2datenum_row, ...
        @timestamp2datenum_col, ...
        @timestamp2datenum_fail_non_vect, ...
        @timestamp2datenum_fail_wrong_format, ...
        @timestamp2datenum_zero};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function duration_str_fail_invalid_dura

    duration_str(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function duration_str_fail_invalid_s_1

    duration_str(1, true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function duration_str_fail_invalid_s_2

    duration_str(1, struct(...
        'days', ' day(s)', ...
        'hours', ' hour(s)', ...
        'minutes', ' minute(s)', ...
        'separator', ', ', ...
        'and', ' and ', ...
        'seconds_fmt', '%2.0f'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_0d

    dura = 0;
    expected = '0 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d

    dura = 1;
    expected = '1 day';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_1h

    dura = 1 + 1 / 24;
    expected = '1 day and 1 hour';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_1h_1m

    dura = 1 + 1 / 24 + 1 / 24 / 60;
    expected = '1 day, 1 hour and 1 minute';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_1h_1m_1s

    dura = 1 + 1 / 24 + 1 / 24 / 60 + 1 / 24 / 60 / 60;
    expected = '1 day, 1 hour, 1 minute and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1h_1m_1s

    dura = 1 / 24 + 1 / 24 / 60 + 1 / 24 / 60 / 60;
    expected = '1 hour, 1 minute and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1m_1s

    dura = 1 / 24 / 60 + 1 / 24 / 60 / 60;
    expected = '1 minute and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1s

    dura = 1 / 24 / 60 / 60;
    expected = '1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_1m_1s

    dura = 1 + 1 / 24 / 60 + 1 / 24 / 60 / 60;
    expected = '1 day, 1 minute and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_1h_1s

    dura = 1 + 1 / 24 + 1 / 24 / 60 / 60;
    expected = '1 day, 1 hour and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_1s

    dura = 1 + 1 / 24 / 60 / 60;
    expected = '1 day and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1h_1m

    dura = 1 / 24 + 1 / 24 / 60;
    expected = '1 hour and 1 minute';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1h

    dura = 1 / 24;
    expected = '1 hour';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1m

    dura = 1 / 24 / 60;
    expected = '1 minute';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_2d_1h_1m_1s

    dura = 2 + 1 / 24 + 1 / 24 / 60 + 1 / 24 / 60 / 60;
    expected = '2 days, 1 hour, 1 minute and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_2h_1m_1s

    dura = 1 + 2 / 24 + 1 / 24 / 60 + 1 / 24 / 60 / 60;
    expected = '1 day, 2 hours, 1 minute and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_1h_2m_1s

    dura = 1 + 1 / 24 + 2 / 24 / 60 + 1 / 24 / 60 / 60;
    expected = '1 day, 1 hour, 2 minutes and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1d_1h_1m_2s

    dura = 1 + 1 / 24 + 1 / 24 / 60 + 2 / 24 / 60 / 60;
    expected = '1 day, 1 hour, 1 minute and 2 seconds';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_negative

    dura = -(2 + 1 / 24 + 1 / 24 / 60 + 1 / 24 / 60 / 60);
    expected = '2 days, 1 hour, 1 minute and 1 second';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_s

    dura = 2 + 1 / 24 + 1 / 24 / 60 + 1 / 24 / 60 / 60;
    expected = '2 jours, 1 heure, 1 minute et 1 seconde';
    ret = strcmp(expected, duration_str(dura, struct(...
        'days', ' jour(s)', ...
        'hours', ' heure(s)', ...
        'minutes', ' minute(s)', ...
        'seconds', ' seconde(s)', ...
        'separator', ', ', ...
        'and', ' et ', ...
        'seconds_fmt', '%.0f')));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = duration_str_1p98s

    dura = 1.98 / 24 / 60 / 60;
    expected = '2 seconds';
    ret = strcmp(expected, duration_str(dura));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp_fail_wrong_type

    timestamp(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp_fail_column

    timestamp([2016 4 18 19 50 26.9863]');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp_fail_numel

    timestamp([2016 4 18 50 26.9863]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp_no_arg_no_error

    timestamp;
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp_scalar

    ret = strcmp(...
        timestamp(736438 + 1 / 24 + 2 / 24 / 60 + 3 / 24 / 60 / 60), ...
        '2016-04-18T01:02:03');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp_vector

    ret = strcmp(timestamp([2016 04 18 1 2 3]), '2016-04-18T01:02:03');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp2filename_fail_wrong_type

    timestamp2filename(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp2filename_empty_string

    ret = isequal(timestamp2filename(''), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp2filename_fail_empty_cell_array

    timestamp2filename({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp2filename_str

    ret = isequal(...
        timestamp2filename('2016-03-14T19:20:21'), '2016-03-14_19-20-21');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp2filename_cellstr

    c = {...
        '2016-03-14T19:20:21', ...
        '2016-03-15T19:21:21', ...
        '2016-03-16T19:22:21'; ...
        '2016-03-17T19:23:21', ...
        '2016-03-18T19:24:21', ...
        '2016-03-19T19:25:21'};

    expected = {...
        '2016-03-14_19-20-21', ...
        '2016-03-15_19-21-21', ...
        '2016-03-16_19-22-21'; ...
        '2016-03-17_19-23-21', ...
        '2016-03-18_19-24-21', ...
        '2016-03-19_19-25-21'};

    ret = isequal(timestamp2filename(c), expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp2filename_char

    ch = [...
        '2016-03-14T19:20:21', ...
        '2016-03-15T19:21:21', ...
        '2016-03-16T19:22:21'; ...
        '2016-03-17T19:23:21', ...
        '2016-03-18T19:24:21', ...
        '2016-03-19T19:25:21'];

    timestamp2filename(ch)

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp2datenum_fail_wrong_type

    timestamp2datenum(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp2datenum_fail_empty_string

    timestamp2datenum('');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp2datenum_fail_empty_cell_array

    timestamp2datenum({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp2datenum_str

    ret = isequal(timestamp2datenum('2016-03-14T19:20:21'), ...
        datenum([2016 3 14 19 20 21]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp2datenum_row

    c = {...
        '2016-03-14T19:20:21', ...
        '2016-03-15T19:21:21', ...
        '2016-03-16T19:22:21', ...
        '2016-03-17T19:23:21', ...
        '2016-03-18T19:24:21', ...
        '2016-03-19T19:25:21'};

    expected = [...
        datenum([2016 3 14 19 20 21]), ...
        datenum([2016 3 15 19 21 21]), ...
        datenum([2016 3 16 19 22 21]), ...
        datenum([2016 3 17 19 23 21]), ...
        datenum([2016 3 18 19 24 21]), ...
        datenum([2016 3 19 19 25 21])];

    ret = isequal(timestamp2datenum(c), expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp2datenum_col

    c = {...
        '2016-03-14T19:20:21', ...
        '2016-03-15T19:21:21', ...
        '2016-03-16T19:22:21', ...
        '2016-03-17T19:23:21', ...
        '2016-03-18T19:24:21', ...
        '2016-03-19T19:25:21'}';

    expected = [...
        datenum([2016 3 14 19 20 21]), ...
        datenum([2016 3 15 19 21 21]), ...
        datenum([2016 3 16 19 22 21]), ...
        datenum([2016 3 17 19 23 21]), ...
        datenum([2016 3 18 19 24 21]), ...
        datenum([2016 3 19 19 25 21])]';

    ret = isequal(timestamp2datenum(c), expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp2datenum_fail_non_vect

    c = {...
        '2016-03-14T19:20:21', ...
        '2016-03-15T19:21:21', ...
        '2016-03-16T19:22:21'; ...
        '2016-03-17T19:23:21', ...
        '2016-03-18T19:24:21', ...
        '2016-03-19T19:25:21'};

    timestamp2datenum(c);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp2datenum_fail_wrong_format

    timestamp2datenum('2016-xx-14T19:20:21');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = timestamp2datenum_zero

    ret = isequal(timestamp2datenum(datestr(0, 'yyyy-mm-ddTHH:MM:SS')), ...
        datenum([-1 12 31 0 0 0]));

endfunction


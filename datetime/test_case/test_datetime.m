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
        @timestamp_fail_nan, ...
        @timestamp_fail_inf, ...
        @timestamp_fail_complex, ...
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
        @timestamp2datenum_zero, ...
        @weeknum_range_fail_wrong_type, ...
        @weeknum_range_fail_non_integer_1, ...
        @weeknum_range_fail_non_integer_2, ...
        @weeknum_range_fail_too_many_elements, ...
        @weeknum_range_fail_too_many_arguments, ...
        @weeknum_range_fail_month_arg_1_too_low, ...
        @weeknum_range_fail_month_arg_1_too_high, ...
        @weeknum_range_fail_arg_2_wrong_type, ...
        @weeknum_range_fail_arg_2_non_integer, ...
        @weeknum_range_fail_month_arg_2_too_low, ...
        @weeknum_range_fail_month_arg_2_too_high, ...
        @weeknum_range_year, ...
        @weeknum_range_month, ...
        @is_leap_yr_fail_too_many_arguments, ...
        @is_leap_yr_matrix};

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

function timestamp_fail_nan

    timestamp(NaN);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp_fail_inf

    timestamp(Inf);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function timestamp_fail_complex

    timestamp(1 + 2i);

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

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_wrong_type

    weeknum_range(true);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_non_integer_1

    weeknum_range(2020.2);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_non_integer_2

    weeknum_range([2020 2.3]);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_too_many_elements

    weeknum_range([2020 2 1]);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_too_many_arguments

    weeknum_range([2020 2], 3);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_month_arg_1_too_low

    weeknum_range([2020 0]);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_month_arg_1_too_high

    weeknum_range([2020 13]);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_arg_2_wrong_type

    weeknum_range(2020, true);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_arg_2_non_integer

    weeknum_range(2020, 2.3);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_month_arg_2_too_low

    weeknum_range(2020, 0);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function weeknum_range_fail_month_arg_2_too_high

    weeknum_range(2020, 13);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = weeknum_range_year

    tested = false(7, 2); % One line for each January 1st week day, column 1
                          % for common years, column 2 for leap years.
    y = 1991;
    failure = false;
    while ~failure && ~all(tested(:)) && y < 2500 % y should not exceed 2016.
        y = y + 1;
        wD = weekday(datenum([y 1 1])) - 1;
        if wD == 0
            wD = 7;
        endif
        leap = (rem (y, 4) == 0 & rem (y, 100) ~= 0) | (rem (y, 400) == 0);
        if leap
            n = 366;
            tested(wD, 2) = true;
        else
            n = 365;
            tested(wD, 1) = true;
        endif
        if wD <= 4
            wN = 1;
        else
            wN = 0;
        endif
        for k = 2 : n
            if wD == 7
                wD = 1;
                wN = wN + 1;
            else
                wD = wD + 1;
            endif
        endfor
        if wD < 4
            wN = wN - 1;
        endif;
        failure = ~isequal(1 : wN, weeknum_range(y));
    endwhile
    ret = ~failure && all(tested(:));

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = weeknum_range_month

    tested = false(12, 7, 2); % One line for each month, one column for each
                              % month first week day, layer 1 for common years,
                              % layer 2 for leap years.
    mL = [31 28 31 30 31 30 31 31 30 31 30 31];
    y = 1991;
    failure = false;
    while ~failure && ~all(tested(:)) && y < 2500 % y should not exceed 2016.
        y = y + 1;
        aY = weeknum_range(y); % Function weeknum_range is assumed validated
                               % by test routine weeknum_range_year for the one
                               % argument usage.
        wD = weekday(datenum([y 1 1])) - 1;
        if wD == 0
            wD = 7;
        endif
        leap = (rem (y, 4) == 0 & rem (y, 100) ~= 0) | (rem (y, 400) == 0);
        if leap
            n = 366;
        else
            n = 365;
        endif
        if wD <= 4
            wN = 1;
        else
            wN = 0;
        endif
        m = 1;
        mD = 1;
        endOfMonth = false;
        k = 1;
        if leap
            tested(m, wD, 2) = true;
        else
            tested(m, wD, 1) = true;
        endif
        a = aY;
        while ~failure && k < n
            k = k + 1;
            if endOfMonth
                m = m + 1;
                mD = 1;
            else
                mD = mD + 1;
            endif
            if leap && m == 2 && mD == 28
                endOfMonth = false;
            else
                endOfMonth = mD == mL(m) || (m == 2 && mD == 29);
            endif
            if wD == 7
                wD = 1;
                wN = wN + 1;
            else
                wD = wD + 1;
            endif
            if endOfMonth && m < 12
                a = a(a <= wN);
            endif
            if mD == 1 % Beginning of month.
                a = aY;
                if leap
                    tested(m, wD, 2) = true;
                else
                    tested(m, wD, 1) = true;
                endif
                a = a(a >= wN);
            endif
            if endOfMonth
                failure = ~isequal(a, weeknum_range(y, m));
            endif
        endwhile
    endwhile
    ret = ~failure && all(tested(:));

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_leap_yr_fail_too_many_arguments

    is_leap_yr(2000, 2);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_leap_yr_matrix

    m = [1600 1700 1800 1900; 2000 2100 2016 2017];
    ret = isequal(is_leap_yr(m), ...
        [true false false false; true false true false]);

endfunction

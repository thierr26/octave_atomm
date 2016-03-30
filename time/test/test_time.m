## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_time ()
##
## Test the time toolbox.
##
## @code{test_time} tests the time toolbox and returns a structure.  This
## structure is a structure returned by @code{run_test_case} and can be used as
## argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_time

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
        @duration_str_s};

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

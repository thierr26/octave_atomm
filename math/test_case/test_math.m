## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_math ()
##
## Test the math toolbox.
##
## @code{test_math} tests the math toolbox and returns a structure.  This
## structure is a structure returned by @code{run_test_case} and can be used as
## argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_math

    # Declare the test routines.
    testRoutine = {...
        @distinct_rand_fail_invalid_a, ...
        @distinct_rand_fail_invalid_max_iter_type, ...
        @distinct_rand_fail_invalid_max_iter_value, ...
        @distinct_rand_empty_a, ...
        @distinct_rand_empty_a_numel_1, ...
        @distinct_rand_empty_a_numel_1_max_iter_1, ...
        @distinct_rand_empty_a_numel_2_row, ...
        @distinct_rand_empty_a_numel_2_col, ...
        @distinct_rand_empty_a_numel_6_3x2, ...
        @wio_consec_duplicates_fail_invalid_x_type, ...
        @wio_consec_duplicates_fail_x_non_row, ...
        @wio_consec_duplicates_fail_x_empty, ...
        @wio_consec_duplicates_fail_x_numeric, ...
        @wio_consec_duplicates_fail_x_logical, ...
        @cell_cum_numel_wrong_arg, ...
        @cell_cum_numel_empty, ...
        @cell_cum_numel_not_empty, ...
        @same_shape_true, ...
        @same_shape_false};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function distinct_rand_fail_invalid_a

    distinct_rand(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function distinct_rand_fail_invalid_max_iter_type

    distinct_rand([], false);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function distinct_rand_fail_invalid_max_iter_value

    distinct_rand([], 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = distinct_rand_empty_a

    r = distinct_rand([]);
    ret = r >= 0 && r <= 1;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = distinct_rand_empty_a_numel_1

    a = 0.6;
    r = distinct_rand(a);
    ret = r >= 0 && r <= 1 && r ~= a;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = distinct_rand_empty_a_numel_1_max_iter_1

    a = 0.6;
    r = distinct_rand(a, 1);
    ret = r >= 0 && r <= 1 && r ~= a;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = distinct_rand_empty_a_numel_2_row

    a = [0.6 0.4]';
    r = distinct_rand(a);
    ret = r >= 0 && r <= 1 && all(r ~= a(:));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = distinct_rand_empty_a_numel_2_col

    a = [0.6 0.4]';
    r = distinct_rand(a);
    ret = r >= 0 && r <= 1 && all(r ~= a(:));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = distinct_rand_empty_a_numel_6_3x2

    a = [0.6 0.4; 0.1 0.2; 0.9 0.5];
    r = distinct_rand(a);
    ret = r >= 0 && r <= 1 && all(r ~= a(:));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function wio_consec_duplicates_fail_invalid_x_type

    wio_consec_duplicates('abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function wio_consec_duplicates_fail_x_non_row

    wio_consec_duplicates([0 0]');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wio_consec_duplicates_fail_x_empty

    ret = isempty(wio_consec_duplicates([]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wio_consec_duplicates_fail_x_numeric

    x = [2.2 2.2 2.5 2.4 2.4 2.3];
    expected = [2.2 2.5 2.4 2.3];
    ret = isequal(expected, wio_consec_duplicates(x));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wio_consec_duplicates_fail_x_logical

    x = [false true true];
    expected = [false true];
    ret = isequal(expected, wio_consec_duplicates(x));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function cell_cum_numel_wrong_arg

    cell_cum_numel(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = cell_cum_numel_empty

    ret = cell_cum_numel({}) == 0;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = cell_cum_numel_not_empty

    ret = cell_cum_numel({'abc', 'defg'}) == 7;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = same_shape_true

    ret = same_shape([1 2], [3 4]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = same_shape_false

    ret = ~same_shape([1 2], [3; 4]);

endfunction

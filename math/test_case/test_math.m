## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_math ()
##
## Run test case for toolbox "math", return results as a structure.
##
## @code{@var{s} = test_math ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_math" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "math".
## @end table
##
## @seealso{mfilename, run_test_case}
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
        @wio_consec_duplicates_fail_x_non_vector, ...
        @wio_consec_duplicates_fail_x_empty, ...
        @wio_consec_duplicates_fail_x_numeric, ...
        @wio_consec_duplicates_fail_x_numeric_column, ...
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

function wio_consec_duplicates_fail_x_non_vector

    wio_consec_duplicates([0 0; 0 0]');

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

function ret = wio_consec_duplicates_fail_x_numeric_column

    x = [2.2 2.2 2.5 2.4 2.4 2.3]';
    expected = [2.2 2.5 2.4 2.3]';
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

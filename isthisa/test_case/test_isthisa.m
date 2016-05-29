## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_isthisa ()
##
## Test the isthisa toolbox.
##
## @code{test_isthisa} tests the isthisa toolbox and returns a structure.  This
## structure is a structure returned by @code{run_test_case} and can be used as
## argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_isthisa

    # Declare the test routines.
    testRoutine = {...
        @is_cell_array_of_func_handle_fail_wrong_nargin_1, ...
        @is_cell_array_of_func_handle_fail_wrong_nargin_2, ...
        @is_cell_array_of_func_handle_false_1, ...
        @is_cell_array_of_func_handle_false_2, ...
        @is_cell_array_of_func_handle_empty_c, ...
        @is_cell_array_of_func_handle_non_empty_c, ...
        @is_string_non_char, ...
        @is_string_non_row, ...
        @is_string_true_empty, ...
        @is_string_true_non_empty, ...
        @is_non_empty_string_non_char, ...
        @is_non_empty_string_non_row, ...
        @is_non_empty_string_false, ...
        @is_non_empty_string_true, ...
        @is_cell_array_of_non_empty_strings_empty_c, ...
        @is_cell_array_of_non_empty_strings_non_cellstr_c, ...
        @is_cell_array_of_non_empty_strings_non_row_char, ...
        @is_cell_array_of_non_empty_strings_numel_1_true, ...
        @is_cell_array_of_non_empty_strings_numel_1_false, ...
        @is_cell_array_of_non_empty_strings_numel_6_3x2_true, ...
        @is_cell_array_of_non_empty_strings_numel_6_3x2_false, ...
        @is_cell_array_of_unique_non_empty_strings_empty_c, ...
        @is_cell_array_of_unique_non_empty_strings_non_cellstr_c, ...
        @is_cell_array_of_unique_non_empty_strings_non_row_char, ...
        @is_cell_array_of_unique_non_empty_strings_numel_1_true, ...
        @is_cell_array_of_unique_non_empty_strings_numel_1_false, ...
        @is_cell_array_of_unique_non_empty_strings_numel_6_3x2_true, ...
        @is_cell_array_of_unique_non_empty_strings_numel_6_3x2_false_1, ...
        @is_cell_array_of_unique_non_empty_strings_numel_6_3x2_false_2, ...
        @is_even_fail_wrong_type, ...
        @is_even_true_m2, ...
        @is_even_false_m1, ...
        @is_even_true_0, ...
        @is_even_false_1, ...
        @is_even_true_2, ...
        @is_even_false_3, ...
        @is_even_true_4, ...
        @is_num_scalar_non_num, ...
        @is_num_scalar_non_scalar, ...
        @is_num_scalar_true, ...
        @is_integer_scalar_non_num, ...
        @is_integer_scalar_non_scalar, ...
        @is_integer_scalar_false, ...
        @is_integer_scalar_true_positive, ...
        @is_integer_scalar_true_negative, ...
        @is_positive_integer_scalar_non_num, ...
        @is_positive_integer_scalar_non_scalar, ...
        @is_positive_integer_scalar_non_int, ...
        @is_positive_integer_scalar_true, ...
        @is_positive_integer_scalar_false, ...
        @is_natural_integer_scalar_non_num, ...
        @is_natural_integer_scalar_non_scalar, ...
        @is_natural_integer_scalar_non_int, ...
        @is_natural_integer_scalar_true, ...
        @is_natural_integer_scalar_false, ...
        @is_logical_scalar_non_logical, ...
        @is_logical_scalar_non_scalar, ...
        @is_logical_scalar_true, ...
        @is_non_empty_scalar_structure_non_struct, ...
        @is_non_empty_scalar_structure_non_scalar, ...
        @is_non_empty_scalar_structure_empty_1, ...
        @is_non_empty_scalar_structure_empty_2, ...
        @is_non_empty_scalar_structure_true, ...
        @is_scalar_num_or_log_literal_wrong_arg, ...
        @is_scalar_num_or_log_literal_1, ...
        @is_scalar_num_or_log_literal_2, ...
        @is_scalar_num_or_log_literal_3, ...
        @is_scalar_num_or_log_literal_4, ...
        @is_scalar_num_or_log_literal_5, ...
        @is_scalar_num_or_log_literal_6, ...
        @is_scalar_num_or_log_literal_7, ...
        @is_scalar_num_or_log_literal_8, ...
        @is_scalar_num_or_log_literal_9, ...
        @is_scalar_num_or_log_literal_10, ...
        @is_scalar_num_or_log_literal_11, ...
        @is_scalar_num_or_log_literal_12, ...
        @is_scalar_num_or_log_literal_13, ...
        @is_scalar_num_or_log_literal_14, ...
        @is_scalar_num_or_log_literal_15, ...
        @is_scalar_num_or_log_literal_16, ...
        @is_scalar_num_or_log_literal_not, ...
        @is_uint8_col_wrong_shape, ...
        @is_uint8_col_wrong_type, ...
        @is_uint8_col_empty, ...
        @is_uint8_col_non_empty, ...
        @is_integer_vect_non_num, ...
        @is_integer_vect_non_vect, ...
        @is_integer_vect_empty, ...
        @is_integer_vect_non_int_row, ...
        @is_integer_vect_non_int_col, ...
        @is_integer_vect_row, ...
        @is_integer_vect_col, ...
        @is_2_dim_cell_non_cell, ...
        @is_2_dim_cell_non_2_dim, ...
        @is_2_dim_cell_empty, ...
        @is_2_dim_cell_row, ...
        @is_2_dim_cell_col, ...
        @is_2_dim_cell_2_dim, ...
        @is_cell_array_of_strings_empty_c, ...
        @is_cell_array_of_strings_non_cellstr_c, ...
        @is_cell_array_of_strings_non_row_char, ...
        @is_cell_array_of_strings_numel_1, ...
        @is_cell_array_of_strings_numel_6_3x2_true, ...
        @is_cell_array_of_strings_numel_6_3x2_false};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function is_cell_array_of_func_handle_fail_wrong_nargin_1

    is_cell_array_of_func_handle;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_cell_array_of_func_handle_fail_wrong_nargin_2

    is_cell_array_of_func_handle({}, {});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_func_handle_false_1

    ret = ~is_cell_array_of_func_handle(@isstruct);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_func_handle_false_2

    ret = ~is_cell_array_of_func_handle({1});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_func_handle_empty_c

    ret = is_cell_array_of_func_handle({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_func_handle_non_empty_c

    ret = is_cell_array_of_func_handle(...
        {@isstruct, @iscell, @islogical; ...
        @isnumeric, @ishandle, @isrow});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_string_non_char

    ret = ~is_string(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_string_non_row

    str = 'abc';
    str = str';
    ret = ~is_string(str);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_string_true_empty

    ret = is_string('');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_string_true_non_empty

    ret = is_string('abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_string_non_char

    ret = ~is_non_empty_string(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_string_non_row

    str = 'abc';
    str = str';
    ret = ~is_non_empty_string(str);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_string_false

    ret = ~is_non_empty_string('');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_string_true

    ret = is_string('abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_non_empty_strings_empty_c

    ret = ~is_cell_array_of_non_empty_strings({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_non_empty_strings_non_cellstr_c

    ret = ~is_cell_array_of_non_empty_strings({0});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_non_empty_strings_non_row_char

    str = 'abc';
    str = str';
    ret = ~is_cell_array_of_non_empty_strings({str});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_non_empty_strings_numel_1_true

    ret = is_cell_array_of_non_empty_strings({'abc'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_non_empty_strings_numel_1_false

    ret = ~is_cell_array_of_non_empty_strings({''});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_non_empty_strings_numel_6_3x2_true

    ret = is_cell_array_of_non_empty_strings(...
        {'abc', 'd', 'ef'; ...
        'ghij', 'k', 'abc'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_non_empty_strings_numel_6_3x2_false

    ret = ~is_cell_array_of_non_empty_strings(...
        {'abc', 'd', 'ef'; ...
        'ghij', '', 'abc'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_unique_non_empty_strings_empty_c

    ret = ~is_cell_array_of_unique_non_empty_strings({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_unique_non_empty_strings_non_cellstr_c

    ret = ~is_cell_array_of_unique_non_empty_strings({0});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_unique_non_empty_strings_non_row_char

    c = 'abc';
    c = c';
    ret = ~is_cell_array_of_unique_non_empty_strings({c});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_unique_non_empty_strings_numel_1_true

    ret = is_cell_array_of_unique_non_empty_strings({'abc'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_unique_non_empty_strings_numel_1_false

    ret = ~is_cell_array_of_unique_non_empty_strings({''});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_unique_non_empty_strings_numel_6_3x2_true

    ret = is_cell_array_of_unique_non_empty_strings(...
        {'abc', 'd', 'ef'; ...
        'ghij', 'k', 'lm'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_unique_non_empty_strings_numel_6_3x2_false_1

    ret = ~is_cell_array_of_unique_non_empty_strings(...
        {'abc', 'd', 'ef'; ...
        'ghij', '', 'lm'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_unique_non_empty_strings_numel_6_3x2_false_2

    ret = ~is_cell_array_of_unique_non_empty_strings(...
        {'abc', 'd', 'ef'; ...
        'ghij', 'k', 'abc'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_even_fail_wrong_type

    is_even(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_even_true_m2

    ret = is_even(-2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_even_false_m1

    ret = ~is_even(-1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_even_true_0

    ret = is_even(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_even_false_1

    ret = ~is_even(1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_even_true_2

    ret = is_even(2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_even_false_3

    ret = ~is_even(3);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_even_true_4

    ret = is_even(4);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_num_scalar_non_num

    ret = ~is_num_scalar(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_num_scalar_non_scalar

    ret = ~is_num_scalar([1.1 2.2]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_num_scalar_true

    ret = is_num_scalar(1.1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_scalar_non_num

    ret = ~is_integer_scalar(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_scalar_non_scalar

    ret = ~is_integer_scalar([1 2]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_scalar_false

    ret = ~is_integer_scalar(3.3);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_scalar_true_positive

    ret = is_integer_scalar(3);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_scalar_true_negative

    ret = is_integer_scalar(-3);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_positive_integer_scalar_non_num

    ret = ~is_positive_integer_scalar(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_positive_integer_scalar_non_scalar

    ret = ~is_positive_integer_scalar([1 2]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_positive_integer_scalar_non_int

    ret = ~is_positive_integer_scalar(3.3);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_positive_integer_scalar_true

    ret = is_positive_integer_scalar(1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_positive_integer_scalar_false

    ret = ~is_positive_integer_scalar(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_natural_integer_scalar_non_num

    ret = ~is_natural_integer_scalar(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_natural_integer_scalar_non_scalar

    ret = ~is_natural_integer_scalar([1 2]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_natural_integer_scalar_non_int

    ret = ~is_natural_integer_scalar(3.3);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_natural_integer_scalar_true

    ret = is_natural_integer_scalar(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_natural_integer_scalar_false

    ret = ~is_natural_integer_scalar(-1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_logical_scalar_non_logical

    ret = ~is_logical_scalar(1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_logical_scalar_non_scalar

    ret = ~is_logical_scalar([false true]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_logical_scalar_true

    ret = is_logical_scalar(false);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_scalar_structure_non_struct

    ret = ~is_non_empty_scalar_structure(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_scalar_structure_non_scalar

    ret = ~is_non_empty_scalar_structure([struct('a', 1) struct('a', 2)]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_scalar_structure_empty_1

    ret = ~is_non_empty_scalar_structure(struct());

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_scalar_structure_empty_2

    ret = ~is_non_empty_scalar_structure(struct([]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_non_empty_scalar_structure_true

    ret = is_non_empty_scalar_structure(struct('a', 1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_scalar_num_or_log_literal_wrong_arg

    is_scalar_num_or_log_literal(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_1

    ret = is_scalar_num_or_log_literal('12');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_2

    ret = is_scalar_num_or_log_literal('+12');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_3

    ret = is_scalar_num_or_log_literal('-12');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_4

    ret = is_scalar_num_or_log_literal('-12.34');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_5

    ret = is_scalar_num_or_log_literal('-12.');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_6

    ret = is_scalar_num_or_log_literal('-.34');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_7

    ret = is_scalar_num_or_log_literal('.34');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_8

    ret = is_scalar_num_or_log_literal('1.234e4');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_9

    ret = is_scalar_num_or_log_literal('1.234e-4');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_10

    ret = is_scalar_num_or_log_literal('1.e-4');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_11

    ret = is_scalar_num_or_log_literal('-1.234e-4');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_12

    ret = is_scalar_num_or_log_literal('1.234E-4');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_13

    ret = is_scalar_num_or_log_literal('1.234E+4');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_14

    ret = is_scalar_num_or_log_literal('1234E+4');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_15

    ret = is_scalar_num_or_log_literal('true');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_16

    ret = is_scalar_num_or_log_literal('false');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_scalar_num_or_log_literal_not

    ret = ~is_scalar_num_or_log_literal('1e.-4');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_uint8_col_wrong_shape

    ret = ~is_uint8_col(zeros(1, 2, 'uint8'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_uint8_col_wrong_type

    ret = ~is_uint8_col(zeros(1, 2, 'int8'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_uint8_col_empty

    ret = is_uint8_col(uint8([]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_uint8_col_non_empty

    ret = is_uint8_col(zeros(2, 1, 'uint8'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_vect_non_num

    ret = ~is_integer_vect([true false]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_vect_non_vect

    ret = ~is_integer_vect([1 2; 3 4]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_vect_empty

    ret = ~is_integer_vect([]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_vect_non_int_row

    ret = ~is_integer_vect([1 2.2 3]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_vect_non_int_col

    ret = ~is_integer_vect([1 2.2 3]');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_vect_row

    ret = is_integer_vect([-1 2 0 3]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_integer_vect_col

    ret = is_integer_vect([-1 2 0 3]');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_2_dim_cell_non_cell

    ret = ~is_2_dim_cell([1 2; 3 4]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_2_dim_cell_non_2_dim

    ret = ~is_2_dim_cell(cell(1, 3, 2));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_2_dim_cell_empty

    ret = is_2_dim_cell({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_2_dim_cell_row

    ret = is_2_dim_cell({'abc', 1});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_2_dim_cell_col

    ret = is_2_dim_cell({'abc'; 1});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_2_dim_cell_2_dim

    ret = is_2_dim_cell({'abc', 1; 2, 'def'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_strings_empty_c

    ret = is_cell_array_of_strings({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_strings_non_cellstr_c

    ret = ~is_cell_array_of_strings({true});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_strings_non_row_char

    str = 'abc';
    str = str';
    ret = ~is_cell_array_of_strings({str});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_strings_numel_1

    ret = is_cell_array_of_strings({'abc'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_strings_numel_6_3x2_true

    ret = is_cell_array_of_strings({'abc', 'd', 'ef'; 'ghij', '', 'lm'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_cell_array_of_strings_numel_6_3x2_false

    ret = ~is_cell_array_of_strings({'abc', true, 'ef'; 'ghij', '', 'lm'});

endfunction

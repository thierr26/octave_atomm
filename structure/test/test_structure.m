## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_structure ()
##
## Test the structure toolbox.
##
## @code{test_structure} tests the structure toolbox and returns a structure.
## This structure is a structure returned by @code{run_test_case} and can be
## used as argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_structure

    # Declare the test routines.
    testRoutine = {...
        @field_names_and_count_fail_invalid_s, ...
        @field_names_and_count_empty_s_1, ...
        @field_names_and_count_empty_s_2, ...
        @field_names_and_count_non_empty_s_1, ...
        @field_names_and_count_non_empty_s_2, ...
        @struct2namevaluepairs_fail_invalid_s, ...
        @struct2namevaluepairs_empty_s_1, ...
        @struct2namevaluepairs_empty_s_2, ...
        @struct2namevaluepairs_non_empty_s_1, ...
        @struct2namevaluepairs_non_empty_s_2, ...
        @merge_struct_fail_wrong_type_1, ...
        @merge_struct_fail_wrong_type_2, ...
        @merge_struct_fail_same_name_in_both, ...
        @merge_struct_empty_1, ...
        @merge_struct_empty_2, ...
        @merge_struct_empty_3, ...
        @merge_struct_empty_4, ...
        @merge_struct_empty_5, ...
        @merge_struct_empty_6, ...
        @merge_struct_scalar, ...
        @merge_struct_array, ...
        };

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function field_names_and_count_fail_invalid_s

    field_names_and_count(0)

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = field_names_and_count_empty_s_1

    s = struct();
    expectedC = cell(0, 1);
    expectedN = 0;
    [c, n] = field_names_and_count(s);
    ret = isequal(c, expectedC) && isequal(n, expectedN);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = field_names_and_count_empty_s_2

    s = struct([]);
    expectedC = cell(0, 1);
    expectedN = 0;
    [c, n] = field_names_and_count(s);
    ret = isequal(c, expectedC) && isequal(n, expectedN);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = field_names_and_count_non_empty_s_1

    s = struct('f1', 1);
    expectedC = {'f1'};
    expectedN = 1;
    [c, n] = field_names_and_count(s);
    ret = isequal(c, expectedC) && isequal(n, expectedN);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = field_names_and_count_non_empty_s_2

    s = struct('f1', 1, 'f2', true);
    expectedC = sort({'f1'; 'f2'});
    expectedN = 2;
    [c, n] = field_names_and_count(s);
    ret = isequal(sort(c), expectedC) && isequal(n, expectedN);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function struct2namevaluepairs_fail_invalid_s

    struct2namevaluepairs(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = struct2namevaluepairs_empty_s_1

    s = struct();
    expected = {};
    c = struct2namevaluepairs(s);
    ret = isequal(c, expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = struct2namevaluepairs_empty_s_2

    s = struct([]);
    expected = {};
    c = struct2namevaluepairs(s);
    ret = isequal(c, expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = struct2namevaluepairs_non_empty_s_1

    s = struct('f1', 1);
    expected = {'f1', 1};
    c = struct2namevaluepairs(s);
    ret = isequal(c, expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = struct2namevaluepairs_non_empty_s_2

    s = struct('f1', 'abc', 'f2', 1);
    expected = {'f1', 'abc', 'f2', 1};
    c = struct2namevaluepairs(s);
    ret = isequal(c, expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function merge_struct_fail_wrong_type_1

    merge_struct(true, struct('abc', 0, 'de', 'wxyz'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function merge_struct_fail_wrong_type_2

    merge_struct(struct('abc', 0, 'de', 'wxyz'), true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function merge_struct_fail_same_name_in_both

    merge_struct(struct('abc', 0, 'de', 'wxyz'), struct('ghi', 0, 'de', 1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = merge_struct_empty_1

    ret = isequal(merge_struct(struct(), struct('ghi', 0, 'de', 1)), ...
        struct('ghi', 0, 'de', 1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = merge_struct_empty_2

    ret = isequal(merge_struct(struct('ghi', 0, 'de', 1), struct()), ...
        struct('ghi', 0, 'de', 1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = merge_struct_empty_3

    ret = isequal(merge_struct(struct([]), struct('ghi', 0, 'de', 1)), ...
        struct('ghi', 0, 'de', 1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = merge_struct_empty_4

    ret = isequal(merge_struct(struct('ghi', 0, 'de', 1), struct([])), ...
        struct('ghi', 0, 'de', 1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = merge_struct_empty_5

    ret = isequal(merge_struct(struct([]), struct([])), struct([]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = merge_struct_empty_6

    ret = isequal(merge_struct(struct(), struct()), struct());

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = merge_struct_scalar

    ret = isequal(...
        merge_struct(struct('abc', 0, 'de', 'wxyz'), ...
        struct('ghi', 0, 'fgh', 1)), ...
        struct('abc', 0, 'de', 'wxyz', 'ghi', 0, 'fgh', 1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function merge_struct_array

    s1 = struct('ghi', 0, 'de', 1);
    s1(2) = s1(1);
    s1(2).ghi = s1(1).ghi + 1;
    s2 = struct('abc', 10, 'fgh', 'wxyz');
    s2(2) = s2(1);
    s2(2).abc = s2(1).abc + 1;
    s2(2).fgh = true;

    merge_struct(s1, s2);

endfunction

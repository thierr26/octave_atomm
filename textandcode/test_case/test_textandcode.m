## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_textandcode ()
##
## Test the textandcode toolbox.
##
## @code{test_textandcode} tests the textandcode toolbox and returns a
## structure.  This structure is a structure returned by @code{run_test_case}
## and can be used as argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_textandcode

    # Declare the test routines.
    testRoutine = {...
        @is_matched_by_fail_invalid_str, ...
        @is_matched_by_fail_invalid_expr, ...
        @is_matched_by_fail_empty_expr, ...
        @is_matched_by_empty, ...
        @is_matched_by_false, ...
        @is_matched_by_true, ...
        @is_matched_by_cellstr, ...
        @is_prefixed_with_fail_invalid_str, ...
        @is_prefixed_with_fail_invalid_prefix, ...
        @is_prefixed_with_fail_empty_prefix, ...
        @is_prefixed_with_empty, ...
        @is_prefixed_with_false, ...
        @is_prefixed_with_true, ...
        @is_prefixed_with_cellstr, ...
        @is_lower_str_than_fail_invalid_str1, ...
        @is_lower_str_than_fail_invalid_str2, ...
        @is_lower_str_than_identical, ...
        @is_lower_str_than_true, ...
        @is_lower_str_than_false, ...
        @wordwrap_fail_wrong_str, ...
        @wordwrap_fail_wrong_n, ...
        @wordwrap_empty, ...
        @wordwrap_short_no_space, ...
        @wordwrap_short_only_spaces, ...
        @wordwrap_short_only_leading_spaces, ...
        @wordwrap_short_only_trailing_spaces, ...
        @wordwrap_short, ...
        @wordwrap_short_leading_trailing, ...
        @wordwrap_long_no_space, ...
        @wordwrap_long_only_spaces, ...
        @wordwrap_long_only_leading_spaces, ...
        @wordwrap_long_only_trailing_spaces, ...
        @wordwrap_long_leading_trailing, ...
        @wordwrap_long, ...
        @wordwrap_long_2, ...
        @wordwrap_long_3, ...
        @wordwrap_long_4, ...
        @wordwrap_long_5, ...
        @is_ascii_file_self, ...
        @quote_delimiters_ok, ...
        @strip_comment_from_line_wrong_arg_1, ...
        @strip_comment_from_line_wrong_arg_2, ...
        @strip_comment_from_line_empty, ...
        @strip_comment_from_line_no_comment_1, ...
        @strip_comment_from_line_no_comment_2, ...
        @strip_comment_from_line_no_comment_3, ...
        @strip_comment_from_line_no_comment_4, ...
        @strip_comment_from_line_comment_1, ...
        @strip_comment_from_line_comment_2, ...
        @strip_comment_from_line_comment_3, ...
        @strip_comment_from_line_comment_4, ...
        @strip_comment_from_line_comment_5, ...
        @strip_comment_from_line_comment_6, ...
        @strip_comment_from_line_comment_7, ...
        @strip_comment_from_line_comment_8, ...
        @strip_comment_from_line_comment_9, ...
        @strip_comment_from_line_comment_10, ...
        @strip_comment_from_line_comment_11, ...
        @strip_comment_from_line_comment_12, ...
        @strip_str_literals_from_line_wrong_arg, ...
        @strip_str_literals_from_line_empty, ...
        @strip_str_literals_from_line_no_str_literals_1, ...
        @strip_str_literals_from_line_no_str_literals_2, ...
        @strip_str_literals_from_line_1, ...
        @strip_str_literals_from_line_2, ...
        @is_ascii_bytes_vect_fail_wrong_v_shape, ...
        @is_ascii_bytes_vect_fail_wrong_v_type, ...
        @is_ascii_bytes_vect_fail_wrong_siz_shape, ...
        @is_ascii_bytes_vect_fail_wrong_siz_type, ...
        @is_ascii_bytes_vect_empty, ...
        @is_ascii_bytes_vect_unix, ...
        @is_ascii_bytes_vect_dos_1, ...
        @is_ascii_bytes_vect_dos_2, ...
        @is_ascii_bytes_vect_null, ...
        @is_ascii_bytes_vect_wrong_dos, ...
        @is_ascii_bytes_vect_mixed_eol, ...
        @is_win_1252_bytes_vect_fail_wrong_v_shape, ...
        @is_win_1252_bytes_vect_fail_wrong_v_type, ...
        @is_win_1252_bytes_vect_fail_wrong_siz_shape, ...
        @is_win_1252_bytes_vect_fail_wrong_siz_type, ...
        @is_win_1252_bytes_vect_empty, ...
        @is_win_1252_bytes_vect_unix, ...
        @is_win_1252_bytes_vect_dos_1, ...
        @is_win_1252_bytes_vect_dos_2, ...
        @is_win_1252_bytes_vect_null, ...
        @is_win_1252_bytes_vect_wrong_dos, ...
        @is_win_1252_bytes_vect_mixed_eol, ...
        @is_win_1252_bytes_vect_129, ...
        @is_win_1252_bytes_vect_141, ...
        @is_win_1252_bytes_vect_143, ...
        @is_win_1252_bytes_vect_144, ...
        @is_win_1252_bytes_vect_157, ...
        @is_iso_8859_bytes_vect_fail_wrong_v_shape, ...
        @is_iso_8859_bytes_vect_fail_wrong_v_type, ...
        @is_iso_8859_bytes_vect_fail_wrong_siz_shape, ...
        @is_iso_8859_bytes_vect_fail_wrong_siz_type, ...
        @is_iso_8859_bytes_vect_empty, ...
        @is_iso_8859_bytes_vect_unix, ...
        @is_iso_8859_bytes_vect_dos_1, ...
        @is_iso_8859_bytes_vect_dos_2, ...
        @is_iso_8859_bytes_vect_null, ...
        @is_iso_8859_bytes_vect_wrong_dos, ...
        @is_iso_8859_bytes_vect_mixed_eol, ...
        @is_iso_8859_bytes_vect_127, ...
        @is_iso_8859_bytes_vect_128, ...
        @is_iso_8859_bytes_vect_159, ...
        @is_iso_8859_bytes_vect_160, ...
        @is_utf8_bytes_vect_fail_wrong_v_shape, ...
        @is_utf8_bytes_vect_fail_wrong_v_type, ...
        @is_utf8_bytes_vect_fail_wrong_siz_shape, ...
        @is_utf8_bytes_vect_fail_wrong_siz_type, ...
        @is_utf8_bytes_vect_empty, ...
        @is_utf8_bytes_vect_unix, ...
        @is_utf8_bytes_vect_dos_1, ...
        @is_utf8_bytes_vect_dos_2, ...
        @is_utf8_bytes_vect_null, ...
        @is_utf8_bytes_vect_wrong_dos, ...
        @is_utf8_bytes_vect_mixed_eol, ...
        @is_utf8_bytes_vect_127, ...
        @is_utf8_bytes_vect_code_2, ...
        @is_utf8_bytes_vect_code_3, ...
        @is_utf8_bytes_vect_code_4, ...
        @is_utf8_bytes_vect_code_3_trunc, ...
        @is_utf8_bytes_vect_code_4_trunc, ...
        @is_utf8_bytes_vect_wrong_code_1, ...
        @is_utf8_bytes_vect_wrong_code_2, ...
        @is_utf8_bytes_vect_wrong_code_3, ...
        @is_utf8_bytes_vect_double_code, ...
        @uncomment_line_fail_wrong_arg_1, ...
        @uncomment_line_fail_wrong_arg_2, ...
        @uncomment_line_empty, ...
        @uncomment_line_no_comment, ...
        @uncomment_line_comment_1, ...
        @uncomment_line_comment_2, ...
        @uncomment_line_comment_3, ...
        @uncomment_line_comment_4, ...
        @strip_dot_suffix_fail_wrong_type, ...
        @strip_dot_suffix_fail_non_str, ...
        @strip_dot_suffix_empty, ...
        @strip_dot_suffix_1_string, ...
        @strip_dot_suffix_1_cell, ...
        @strip_dot_suffix_3_cells_row, ...
        @strip_dot_suffix_3_cells_col, ...
        @strip_dot_suffix_mat, ...
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
        @is_scalar_num_or_log_literal_not};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function is_matched_by_fail_invalid_str

    is_matched_by(true, 'xyz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_matched_by_fail_invalid_expr

    is_matched_by('xyz', true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_matched_by_fail_empty_expr

    is_matched_by('xyz', '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_matched_by_empty

    ret = ~is_matched_by('', 'xyz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_matched_by_false

    ret = ~is_matched_by('abcd', 'xyz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_matched_by_true

    ret = is_matched_by('xyz', 'xyz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_matched_by_cellstr

    ret = isequal(is_matched_by(...
        {'one', 'two', 'three'; 'four', 'five', 'six'}, '^[tf]'), ...
        [false true true; true true false]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_prefixed_with_fail_invalid_str

    is_prefixed_with(true, 'xyz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_prefixed_with_fail_invalid_prefix

    is_prefixed_with('xyz', true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_prefixed_with_fail_empty_prefix

    is_prefixed_with('xyz', '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_prefixed_with_empty

    ret = ~is_prefixed_with('', 'xyz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_prefixed_with_false

    ret = ~is_prefixed_with('abcd', 'xyz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_prefixed_with_true

    ret = is_prefixed_with('xyz', 'xyz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_prefixed_with_cellstr

    ret = isequal(is_prefixed_with(...
        {'one', 'two', 'three'; 'four', 'five', 'six'}, 'f'), ...
        [false false false; true true false]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_lower_str_than_fail_invalid_str1

    is_lower_str_than(true, 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_lower_str_than_fail_invalid_str2

    is_lower_str_than('abc', true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_lower_str_than_identical

    ret = ~is_lower_str_than('abc', 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_lower_str_than_true

    ret = is_lower_str_than('abc', 'def');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_lower_str_than_false

    ret = ~is_lower_str_than('def', 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function wordwrap_fail_wrong_str

    wordwrap(0, 25);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function wordwrap_fail_wrong_n

    wordwrap('abc', true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_empty

    ret = isequal(wordwrap('', 25), {''});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_short_no_space

    ret = isequal(wordwrap('abc', 25), {'abc'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_short_only_spaces

    ret = isequal(wordwrap('   ', 25), {'   '});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_short_only_leading_spaces

    ret = isequal(wordwrap('  abc', 25), {'  abc'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_short_only_trailing_spaces

    ret = isequal(wordwrap('abc  ', 25), {'abc  '});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_short

    ret = isequal(wordwrap('abc def ghi jkl', 25), {'abc def ghi jkl'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_short_leading_trailing

    ret = isequal(wordwrap(' abc def ghi jkl ', 25), {' abc def ghi jkl '});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_no_space

    ret = isequal(wordwrap('abcdefghijklmnopqrstuvwxyz', 10), ...
        {'abcdefghijklmnopqrstuvwxyz'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_only_spaces

    ret = isequal(wordwrap('                          ', 10), ...
        {'                          '});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_only_leading_spaces

    ret = isequal(wordwrap('  abcdefghijklmnopqrstuvwxyz', 10), ...
        {'  abcdefghijklmnopqrstuvwxyz'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_only_trailing_spaces

    ret = isequal(wordwrap('abcdefghijklmnopqrstuvwxyz  ', 10), ...
        {'abcdefghijklmnopqrstuvwxyz  '});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_leading_trailing

    ret = isequal(wordwrap(['                       Life ' ...
        'by Charles Hamilton Musgrove '], 29), ...
        {'                       Life', ...
        'by Charles Hamilton Musgrove '});

endfunction
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long

    ret = isequal(wordwrap([...
        'Life is just a web of doubt Where, with iridescent gleams, ' ...
        'Flickers in or struggles out Love, the golden moth of dreams.'], ...
        32), {...
        'Life is just a web of doubt', ...
        'Where, with iridescent gleams,', ...
        'Flickers in or struggles out', ...
        'Love, the golden moth of dreams.'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_2

    ret = isequal(wordwrap([...
        'Life is just a web of doubt Where, with iridescent gleams, ' ...
        'Flickers in or struggles out Love, the golden moth of dreams.'], ...
        34), {...
        'Life is just a web of doubt Where,', ...
        'with iridescent gleams, Flickers', ...
        'in or struggles out Love, the', ...
        'golden moth of dreams.'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_3

    ret = isequal(wordwrap([...
        'Life is just a web of doubt Where, with iridescent gleams, ' ...
        'Flickers in or struggles zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz ' ...
        'out Love, the golden moth of dreams.'], ...
        34), {...
        'Life is just a web of doubt Where,', ...
        'with iridescent gleams, Flickers', ...
        'in or struggles', ...
        'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz', ...
        'out Love, the golden moth of', ...
        'dreams.'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_4

    ret = isequal(wordwrap([...
        'Life is just a web of doubt Where, with iridescent gleams, ' ...
        'Flickers in or struggles zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz ' ...
        'out Love, the golden moth of dreams.'], ...
        1), {...
        'Life', ...
        'is', ...
        'just', ...
        'a', ...
        'web', ...
        'of', ...
        'doubt', ...
        'Where,', ...
        'with', ...
        'iridescent', ...
        'gleams,', ...
        'Flickers', ...
        'in', ...
        'or', ...
        'struggles', ...
        'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz', ...
        'out', ...
        'Love,', ...
        'the', ...
        'golden', ...
        'moth', ...
        'of', ...
        'dreams.'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = wordwrap_long_5

    ret = isequal(wordwrap([...
        'z Life is just a web of doubt Where, with iridescent gleams, ' ...
        'Flickers in or struggles zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz ' ...
        'out Love, the golden moth of dreams.'], ...
        1), {...
        'z', ...
        'Life', ...
        'is', ...
        'just', ...
        'a', ...
        'web', ...
        'of', ...
        'doubt', ...
        'Where,', ...
        'with', ...
        'iridescent', ...
        'gleams,', ...
        'Flickers', ...
        'in', ...
        'or', ...
        'struggles', ...
        'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz', ...
        'out', ...
        'Love,', ...
        'the', ...
        'golden', ...
        'moth', ...
        'of', ...
        'dreams.'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_ascii_file_self

    ret = is_ascii_file(fullmfilename);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = quote_delimiters_ok

    c = quote_delimiters;
    ret = ismember('''', c) && ismember('"', c);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_comment_from_line_wrong_arg_1

    strip_comment_from_line(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_comment_from_line_wrong_arg_2

    strip_comment_from_line('', true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_empty

    ret = isequal(strip_comment_from_line(''), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_no_comment_1

    ret = isequal(strip_comment_from_line('abc'), 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_no_comment_2

    ret = isequal(strip_comment_from_line('abc ''def % ghi'' def'), ...
        'abc ''def % ghi'' def');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_no_comment_3

    ret = isequal(strip_comment_from_line('abc + [1 2 3]'''), ...
        'abc + [1 2 3]''');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_no_comment_4

    ret = isequal(strip_comment_from_line('''abc'''), '''abc''');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_1

    ret = isequal(strip_comment_from_line('# abc'), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_2

    ret = isequal(strip_comment_from_line('## abc'), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_3

    ret = isequal(strip_comment_from_line('    # abc'), '    ');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_4

    ret = isequal(strip_comment_from_line('def # abc'), 'def ');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_5

    ret = isequal(strip_comment_from_line('abc ''def % ghi'' def # zzz'), ...
        'abc ''def % ghi'' def ');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_6

    ret = isequal(strip_comment_from_line('abc + [1 2 3]'' # zzz'), ...
        'abc + [1 2 3]'' ');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_7

    ret = isequal(strip_comment_from_line('% abc'), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_8

    ret = isequal(strip_comment_from_line('%% abc'), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_9

    ret = isequal(strip_comment_from_line('    % abc'), '    ');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_10

    ret = isequal(strip_comment_from_line('def % abc'), 'def ');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_11

    ret = isequal(strip_comment_from_line('abc ''def # ghi'' def % zzz'), ...
        'abc ''def # ghi'' def ');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_comment_from_line_comment_12

    ret = isequal(strip_comment_from_line('abc + [1 2 3]'' % zzz'), ...
        'abc + [1 2 3]'' ');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_str_literals_from_line_wrong_arg

    strip_str_literals_from_line(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_str_literals_from_line_empty

    ret = isequal(strip_str_literals_from_line(''), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_str_literals_from_line_no_str_literals_1

    ret = isequal(strip_str_literals_from_line('abc'), 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_str_literals_from_line_no_str_literals_2

    ret = isequal(strip_str_literals_from_line('abc + [1 2 3]'''), ...
        'abc + [1 2 3]''');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_str_literals_from_line_1

    ret = isequal(strip_str_literals_from_line('abc ''def % ghi'' def'), ...
        'abc  def');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_str_literals_from_line_2

    ret = isequal(strip_str_literals_from_line('''abc'''), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_ascii_bytes_vect_fail_wrong_v_shape

    is_ascii_bytes_vect(zeros(1, 2, 'uint8'), 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_ascii_bytes_vect_fail_wrong_v_type

    is_ascii_bytes_vect(zeros(2, 1, 'int8'), 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_ascii_bytes_vect_fail_wrong_siz_shape

    is_ascii_bytes_vect(zeros(2, 1, 'int8'), [2 3]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_ascii_bytes_vect_fail_wrong_siz_type

    is_ascii_bytes_vect(zeros(2, 1, 'int8'), true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_ascii_bytes_vect_empty

    ret = is_ascii_bytes_vect(uint8([]), 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_ascii_bytes_vect_unix

    ret = is_ascii_bytes_vect(uint8([9 32 126 10 97 10]'), 6);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_ascii_bytes_vect_dos_1

    ret = is_ascii_bytes_vect(uint8([9 32 126 13 10 97 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_ascii_bytes_vect_dos_2

    ret = is_ascii_bytes_vect(uint8([9 32 126 13 10 97 13]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_ascii_bytes_vect_null

    ret = ~is_ascii_bytes_vect(uint8([9 32 126 13 10 0 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_ascii_bytes_vect_wrong_dos

    ret = ~is_ascii_bytes_vect(uint8([9 32 126 13 97 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_ascii_bytes_vect_mixed_eol

    ret = is_ascii_bytes_vect(uint8([9 32 126 10 97 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_win_1252_bytes_vect_fail_wrong_v_shape

    is_win_1252_bytes_vect(zeros(1, 2, 'uint8'), 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_win_1252_bytes_vect_fail_wrong_v_type

    is_win_1252_bytes_vect(zeros(2, 1, 'int8'), 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_win_1252_bytes_vect_fail_wrong_siz_shape

    is_win_1252_bytes_vect(zeros(2, 1, 'int8'), [2 3]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_win_1252_bytes_vect_fail_wrong_siz_type

    is_win_1252_bytes_vect(zeros(2, 1, 'int8'), true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_empty

    ret = is_win_1252_bytes_vect(uint8([]), 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_unix

    ret = is_win_1252_bytes_vect(uint8([9 32 126 10 128 10]'), 6);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_dos_1

    ret = is_win_1252_bytes_vect(uint8([9 32 126 13 10 128 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_dos_2

    ret = is_win_1252_bytes_vect(uint8([9 32 126 13 10 128 13]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_null

    ret = ~is_win_1252_bytes_vect(uint8([9 32 126 13 10 0 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_wrong_dos

    ret = ~is_win_1252_bytes_vect(uint8([9 32 126 13 128 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_mixed_eol

    ret = is_win_1252_bytes_vect(uint8([9 32 126 10 128 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_129

    ret = ~is_win_1252_bytes_vect(uint8([9 32 126 10 129 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_141

    ret = ~is_win_1252_bytes_vect(uint8([9 32 126 10 141 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_143

    ret = ~is_win_1252_bytes_vect(uint8([9 32 126 10 143 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_144

    ret = ~is_win_1252_bytes_vect(uint8([9 32 126 10 144 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_win_1252_bytes_vect_157

    ret = ~is_win_1252_bytes_vect(uint8([9 32 126 10 157 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_iso_8859_bytes_vect_fail_wrong_v_shape

    is_iso_8859_bytes_vect(zeros(1, 2, 'uint8'), 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_iso_8859_bytes_vect_fail_wrong_v_type

    is_iso_8859_bytes_vect(zeros(2, 1, 'int8'), 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_iso_8859_bytes_vect_fail_wrong_siz_shape

    is_iso_8859_bytes_vect(zeros(2, 1, 'int8'), [2 3]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_iso_8859_bytes_vect_fail_wrong_siz_type

    is_iso_8859_bytes_vect(zeros(2, 1, 'int8'), true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_empty

    ret = is_iso_8859_bytes_vect(uint8([]), 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_unix

    ret = is_iso_8859_bytes_vect(uint8([9 32 126 10 160 10]'), 6);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_dos_1

    ret = is_iso_8859_bytes_vect(uint8([9 32 126 13 10 160 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_dos_2

    ret = is_iso_8859_bytes_vect(uint8([9 32 126 13 10 160 13]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_null

    ret = ~is_iso_8859_bytes_vect(uint8([9 32 126 13 10 0 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_wrong_dos

    ret = ~is_iso_8859_bytes_vect(uint8([9 32 126 13 160 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_mixed_eol

    ret = is_iso_8859_bytes_vect(uint8([9 32 126 10 160 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_127

    ret = ~is_iso_8859_bytes_vect(uint8([9 32 126 10 127 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_128

    ret = ~is_iso_8859_bytes_vect(uint8([9 32 126 10 128 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_159

    ret = ~is_iso_8859_bytes_vect(uint8([9 32 126 10 159 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_iso_8859_bytes_vect_160

    ret = is_iso_8859_bytes_vect(uint8([9 32 126 10 160 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_utf8_bytes_vect_fail_wrong_v_shape

    is_utf8_bytes_vect(zeros(1, 2, 'uint8'), 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_utf8_bytes_vect_fail_wrong_v_type

    is_utf8_bytes_vect(zeros(2, 1, 'int8'), 2);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_utf8_bytes_vect_fail_wrong_siz_shape

    is_utf8_bytes_vect(zeros(2, 1, 'int8'), [2 3]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_utf8_bytes_vect_fail_wrong_siz_type

    is_utf8_bytes_vect(zeros(2, 1, 'int8'), true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_empty

    ret = is_utf8_bytes_vect(uint8([]), 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_unix

    ret = is_utf8_bytes_vect(uint8([9 32 126 10 97 10]'), 6);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_dos_1

    ret = is_utf8_bytes_vect(uint8([9 32 126 13 10 97 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_dos_2

    ret = is_utf8_bytes_vect(uint8([9 32 126 13 10 97 13]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_null

    ret = ~is_utf8_bytes_vect(uint8([9 32 126 13 10 0 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_wrong_dos

    ret = ~is_utf8_bytes_vect(uint8([9 32 126 13 97 13 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_mixed_eol

    ret = is_utf8_bytes_vect(uint8([9 32 126 10 97 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_127

    ret = ~is_utf8_bytes_vect(uint8([9 32 126 10 127 13 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_code_2

    ret = is_utf8_bytes_vect(uint8([9 32 126 10 192 128 10]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_code_3

    ret = is_utf8_bytes_vect(uint8([9 32 126 10 224 128 128 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_code_4

    ret = is_utf8_bytes_vect(uint8([9 32 126 10 240 128 128 128 10]'), 9);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_code_3_trunc

    ret = is_utf8_bytes_vect(uint8([9 32 126 10 224 128]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_code_4_trunc

    ret = is_utf8_bytes_vect(uint8([9 32 126 10 240 128 128]'), 7);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_wrong_code_1

    ret = ~is_utf8_bytes_vect(uint8([9 32 126 10 224 128 97 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_wrong_code_2

    ret = ~is_utf8_bytes_vect(uint8([9 32 126 10 224 97 128 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_wrong_code_3

    ret = ~is_utf8_bytes_vect(uint8([9 32 126 10 192 128 128 10]'), 8);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_utf8_bytes_vect_double_code

    ret = is_utf8_bytes_vect(...
        uint8([9 32 126 10 224 128 128 224 128 128 10]'), 11);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function uncomment_line_fail_wrong_arg_1

    uncomment_line(true, 'ab');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function uncomment_line_fail_wrong_arg_2

    uncomment_line('ab', true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = uncomment_line_empty

    str = '';
    ret = strcmp(uncomment_line(str), str);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = uncomment_line_no_comment

    str = '  abc';
    ret = strcmp(uncomment_line(str), str);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = uncomment_line_comment_1

    ret = strcmp(uncomment_line('%# abc'), 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = uncomment_line_comment_2

    ret = strcmp(uncomment_line('    // abc', '/'), 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = uncomment_line_comment_3

    ret = strcmp(uncomment_line('%#abc'), 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = uncomment_line_comment_4

    ret = strcmp(uncomment_line('    //abc', '/'), 'abc');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_dot_suffix_fail_wrong_type

    strip_dot_suffix(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_dot_suffix_fail_non_str

    strip_dot_suffix({1, 2});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_dot_suffix_empty

    ret = isequal(strip_dot_suffix({}), {});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_dot_suffix_1_string

    ret = isequal(strip_dot_suffix('www.gnu.org'), 'www.gnu');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_dot_suffix_1_cell

    ret = isequal(strip_dot_suffix({'www.gnu.org'}), {'www.gnu'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_dot_suffix_3_cells_row

    ret = isequal(strip_dot_suffix(...
        {'www.gnu.org', 'www.linux.com', 'www.debian.org'}), ...
        {'www.gnu', 'www.linux', 'www.debian'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_dot_suffix_3_cells_col

    ret = isequal(strip_dot_suffix(...
        {'www.gnu.org'; 'www.linux.com'; 'www.debian.org'}), ...
        {'www.gnu'; 'www.linux'; 'www.debian'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_dot_suffix_mat

    ret = isequal(strip_dot_suffix(...
        {'www.gnu.org', 'foo', 'www.debian.org'; ...
        '', 'www.linux.com', 'bar'}), ...
        {'www.gnu', 'foo', 'www.debian'; ...
        '', 'www.linux', 'bar'});

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

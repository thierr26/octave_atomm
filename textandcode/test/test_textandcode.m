## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_textandcode ()
##
## Test the textandcode toolbox.
##
## @code{test_textandcode} tests the textandcode toolbox and returns a
## structure.  this structure is a structure returned by @code{run_test_case}
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
        @m_file_filters_no_arg, ...
        @m_file_filters_all, ...
        @m_file_filters_m_lang_only, ...
        @m_comment_leaders_ok, ...
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
        @is_utf8_bytes_vect_double_code};

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

function ret = m_file_filters_no_arg

    c = {'*.m', '*.p'};
    if is_octave
        ret = isequal(m_file_filters('all'), c(1));
    else
        ret = isequal(m_file_filters('all'), c);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = m_file_filters_all

    c = {'*.m', '*.p'};
    if is_octave
        ret = isequal(m_file_filters('all'), c(1));
    else
        ret = isequal(m_file_filters('all'), c);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = m_file_filters_m_lang_only

    c = {'*.m', '*.p'};
    ret = isequal(m_file_filters('m_lang_only'), c(1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = m_comment_leaders_ok

    c = m_comment_leaders;
    ret = ismember('%', c) && ismember('#', c);

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

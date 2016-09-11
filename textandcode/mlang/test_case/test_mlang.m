## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_mlang ()
##
## Run test case for toolbox "mlang", return results as a structure.
##
## @code{@var{s} = test_mlang ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_mlang" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "mlang".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_mlang

    # Declare the test routines.
    testRoutine = {...
        @m_file_filters_no_arg, ...
        @m_file_filters_all, ...
        @m_file_filters_m_lang_only, ...
        @m_comment_leaders_ok, ...
        @is_identifier_fail_wrong_type, ...
        @is_identifier_ok, ...
        @is_identifier_empty, ...
        @is_identifier_too_long, ...
        @is_identifier_keyword, ...
        @is_identifier_space, ...
        @is_identifier_start_with_digit};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = m_file_filters_no_arg

    if is_octave
        c = {'*.m', ['*.' mexext], '*.oct'};
        ret = isequal(m_file_filters, c);
    else
        c = {'*.m', '*.p', ['*.' mexext]};
        ret = isequal(m_file_filters, c);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = m_file_filters_all

    if is_octave
        c = {'*.m', ['*.' mexext], '*.oct'};
        ret = isequal(m_file_filters('all'), c);
    else
        c = {'*.m', '*.p', ['*.' mexext]};
        ret = isequal(m_file_filters('all'), c);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = m_file_filters_m_lang_only

    c = {'*.m'};
    ret = isequal(m_file_filters('m_lang_only'), c);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = m_comment_leaders_ok

    c = m_comment_leaders;
    ret = ismember('%', c) && ismember('#', c);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_identifier_fail_wrong_type

    is_identifier(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_identifier_ok

    identifier = repmat('x', [1 namelengthmax]);
    ret = is_identifier(identifier);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_identifier_empty

    ret = ~is_identifier('');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_identifier_too_long

    identifier = repmat('x', [1 namelengthmax + 1]);
    ret = ~is_identifier(identifier);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_identifier_keyword

    ret = ~is_identifier('global');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_identifier_space

    ret = ~is_identifier('abc def');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_identifier_start_with_digit

    ret = ~is_identifier('1x');

endfunction

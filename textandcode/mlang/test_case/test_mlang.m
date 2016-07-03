## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_mlang ()
##
## Test the mlang toolbox.
##
## @code{test_mlang} tests the textandcode toolbox and returns a structure.
## This structure is a structure returned by @code{run_test_case} and can be
## used as argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_mlang

    # Declare the test routines.
    testRoutine = {...
        @m_file_filters_no_arg, ...
        @m_file_filters_all, ...
        @m_file_filters_m_lang_only, ...
        @m_comment_leaders_ok};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

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

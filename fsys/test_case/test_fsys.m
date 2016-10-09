## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_fsys ()
##
## Run test case for toolbox "fsys", return results as a structure.
##
## @code{@var{s} = test_fsys ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_fsys" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "fsys".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_fsys

    # Declare the test routines.
    testRoutine = {...
        @absolute_path_fail_too_many_args, ...
        @absolute_path_fail_wrong_index, ...
        @absolute_path_fail_wrong_s, ...
        @absolute_path_abs, ...
        @absolute_path_rel, ...
        @absolute_path_dot, ...
        @find_files_empty_s_no_error, ...
        @ignored_dir_list_no_error, ...
        @rotate_file_no_error, ...
        @rotate_file_dir, ...
        @find_files_no_error_1, ...
        @find_files_no_error_2, ...
        @file_byte_size_no_error, ...
        @file_ext_fail_wrong_type, ...
        @file_ext_empty_filename, ...
        @file_ext_empty_ext, ...
        @file_ext_non_empty_ext, ...
        @is_mat_file_name_fail_wrong_type, ...
        @is_mat_file_name_empty, ...
        @is_mat_file_name_false, ...
        @is_mat_file_name_true};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function str = atomm_dir

    str = fullmfilename;
    name = '';
    while ~strcmp(name, 'atomm')
        [str, name] = fileparts(str);
    endwhile
    str = fullfile(str, name);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = root

    c = regexp(pwd, ['^(.:)?\' filesep], 'match');
    ret = c{1};
    if ispc
        assert(is_matched_by(ret, ['^[A-Za-z]:\' filesep]));
    else
        assert(strcmp(ret, filesep));
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function absolute_path_fail_too_many_args

    absolute_path('abc', 1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function absolute_path_fail_wrong_index

    absolute_path(find_files_empty_s, 1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function absolute_path_fail_wrong_s

    absolute_path(struct(), 1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = absolute_path_abs

    str = fullfile(root, fullfile('abc', 'defg'));
    expected = str;
    ret = strcmp(absolute_path(str), expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = absolute_path_rel

    str = fullfile('abc', 'defg');
    expected = fullfile(pwd, str);
    ret = strcmp(absolute_path(str), expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = absolute_path_dot

    str = fullfile(fullfile('.', 'abc'), fullfile('..', 'defg'));
    expected = fullfile(pwd, 'defg');
    ret = strcmp(absolute_path(str), expected);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = find_files_empty_s_no_error

    find_files_empty_s;
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = ignored_dir_list_no_error

    ignored_dir_list;
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = rotate_file_no_error

    rotate_file(fullmfilename, 10e6);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function rotate_file_dir

    rotate_file(fileparts (fullmfilename), 10e6);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = find_files_no_error_1

    find_files(atomm_dir);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = find_files_no_error_2

    s = find_files_empty_s;
    s = find_files(s, atomm_dir, '*.m');
    find_files(s, atomm_dir, 'dependencies');
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = file_byte_size_no_error

    file_byte_size(fullmfilename);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function file_ext_fail_wrong_type

    file_ext(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = file_ext_empty_filename

    ret = strcmp(file_ext(''), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = file_ext_empty_ext

    ret = strcmp(file_ext('abc'), '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = file_ext_non_empty_ext

    ret = strcmp(file_ext('abc.def'), '.def');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_mat_file_name_fail_wrong_type

    is_mat_file_name(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_mat_file_name_empty

    ret = ~is_mat_file_name('');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_mat_file_name_false

    ret = ~is_mat_file_name('abc.mat.txt');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_mat_file_name_true

    ret = is_mat_file_name('abc.mat');

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_fsys ()
##
## Test the fsys toolbox.
##
## @code{test_fsys} tests the fsys toolbox and returns a structure.  This
## structure is a structure returned by @code{run_test_case} and can be used as
## argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
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
        @is_find_files_s_no_error, ...
        @ignored_dir_list_no_error, ...
        @rotate_file_no_error, ...
        @rotate_file_dir, ...
        @find_files_no_error_1, ...
        @find_files_no_error_2, ...
        @find_files_depth, ...
        @file_byte_size_no_error, ...
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

function ret = is_find_files_s_no_error

    ret = is_find_files_s(find_files_empty_s);

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

function ret = find_files_depth

    s1 = find_files(atomm_dir, '*.m');
    s2 = find_files(s1, fullfile(atomm_dir, 'env'), 'dependencies', 1);
    ret = isequal(s1, s2);
    s3 = find_files(s2, fullfile(atomm_dir, 'env'), 'dependencies', 2);
    ret = ret && ~isequal(s2, s3);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = file_byte_size_no_error

    file_byte_size(fullmfilename);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_mat_file_name_fail_wrong_type

    is_mat_file_name(true);

end

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_mat_file_name_empty

    ret = ~is_mat_file_name('');

end

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_mat_file_name_false

    ret = ~is_mat_file_name('abc.def');

end

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_mat_file_name_true

    ret = is_mat_file_name('abc.mat');

end

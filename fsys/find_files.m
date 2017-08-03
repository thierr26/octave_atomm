## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} find_files ()
## @deftypefnx {Function File} {@var{s} =} find_files (@var{top})
## @deftypefnx {Function File} {@var{s} =} find_files (@var{top}, @var{filter})
## @deftypefnx {Function File} {@var{s} =} find_files (@var{top}, @var{@
## filter}, @var{max_depth})
## @deftypefnx {Function File} {@var{s} =} find_files (@var{top}, @var{@
## filter}, @var{max_depth}, @var{ignored_dirs})
## @deftypefnx {Function File} {@var{s} =} find_files (@var{s1}, @var{top})
## @deftypefnx {Function File} {@var{s} =} find_files (@var{s1}, @var{@
## top}, @var{filter})
## @deftypefnx {Function File} {@var{s} =} find_files (@var{s1}, @var{@
## top}, @var{filter}, @var{max_depth})
## @deftypefnx {Function File} {@var{s} =} find_files (@var{s1}, @var{@
## top}, @var{filter}, @var{max_depth}, @var{ignored_dirs})
## @deftypefnx {Function File} {@var{s} =} find_files (@var{s1}, @var{@
## top}, @var{filter}, @var{max_depth}, @var{ignored_dirs}, @var{no_check})
##
## Find files recursively.
##
## @strong{Explore a directory tree.}
##
## @code{@var{s} = find_files ()} scans the current working directory and its
## subdirectories and returns a structure containing the following fields:
##
## @table @asis
## @item @qcode{"dir"}
## A cell array of strings containing the absolute path to the current working
## directory and the absolute path to every subdirectory recursively found.
## The directories that have their name in the cell array of strings returned
## by function @code{ignored_dir_list} are omitted.
##
## @item @qcode{"file"}
## A cell array of strings containing the base names of the files found in the
## directories present in the @qcode{"dir"} field.  The files are grouped by
## parent directory.
##
## @item @qcode{"bytes"}
## A vector having the same shape as the @qcode{"file"} field containing the
## byte sizes of the files (similar to the @qcode{"bytes"} field structures
## returned by function @code{dir}).
##
## @item @qcode{"datenum"}
## A vector having the same shape as the @qcode{"file"} field containing the
## dates of modification of the files as serial date numbers (similar to the
## @qcode{"datenum"} field structures returned by function @code{dir}).
##
## @item @qcode{"dir_idx"}
## A vector having the same shape as the @qcode{"file"} field containing the
## index in field @qcode{"dir"} of the directory to which the file belongs.
##
## @item @qcode{"first_file_idx"}
## A vector having the same shape as the @qcode{"dir"} field containing the
## index in @qcode{"file"} of the first file found in the directory (or 1 if no
## file was found in the directory).
##
## @item @qcode{"last_file_idx"}
## A vector having the same shape as the @qcode{"dir"} field containing the
## index in @qcode{"file"} of the last file found in the directory (or 0 if no
## file was found in the directory).
## @end table
##
## For example, let's assume that your current working directory is like the
## following tree:
##
## @verbatim
## current_working_directory
## |
## |-file_1
## |-file_2
## |
## |-subdir_1
## | |
## | |-file_3
## | |-file_4
## |
## |-subdir_2
## | |
## | |-subsubdir
## |   |
## |   |-file_5
## |
## |-subdir_3
##   |
##   |-file_6
##   |-file_7
## @end verbatim
##
## The @code{@var{s} = find_files ()} statement returns a @var{s} structure
## like:
##
## @verbatim
## S =
##
##   scalar structure containing the fields:
##
##     dir = <directories and subdirectories, including working directory>
##     {
##       [1,1] = current/working/directory
##       [1,2] = current/working/directory/subdir_1
##       [1,3] = current/working/directory/subdir_2
##       [1,4] = current/working/directory/subdir_2/subsubdir
##       [1,5] = current/working/directory/subdir_3
##     }
##     file = <files found, grouped by parent directory>
##     {
##       [1,1] = file_1
##       [1,2] = file_2
##       [1,3] = file_3
##       [1,4] = file_4
##       [1,5] = file_5
##       [1,6] = file_6
##       [1,7] = file_7
##     }
##
##     first_file_idx = <for every directory, index of first file>
##
##        1   3   1   5   6
##
##     last_file_idx = <for every dir., index of last file (0 if no file)>
##
##        2   4   0   5   7
##
##     dir_idx = <for every file, index of directory>
##
##        1   1   2   2   4   5   5
##
##     bytes = <for every file, byte size>
##
##        <size_1> <size_2> <size_3> <size_4> <size_5> <size_6> <size_7>
##
##     datenum = <for every file, modification date (serial date number)>
##
##        <date_1> <date_2> <date_3> <date_4> <date_5> <date_6> <date_7>
## @end verbatim
##
## If you want to explore another directory than your current working
## directory, provide this directory as an argument to @code{find_files}:
##
## @example
## @group
## @var{s} = find_files ('path/to/the/directory/to/explore')
## @end group
## @end example
##
## @strong{Use @code{absolute_path} to get the absolute path to a file.}
##
## Function @code{absolute_path} can be used to get back the absolute path to a
## file from the @qcode{"file"} field of the @code{find_files} return
## structure.  Just provide @code{find_files} return structure and the index of
## the file as arguments to @code{absolute_path}.
##
## This code:
##
## @example
## @group
## @var{s} = find_files ();
## for @var{k} = 1 : numel (@var{s}.file)
##     disp (absolute_path (@var{s}, @var{k}))
## end
## @end group
## @end example
##
## is equivalent to:
##
## @example
## @group
## @var{s} = find_files ();
## for @var{k} = 1 : numel (@var{s}.file)
##     disp (fullfile (...
##         @var{s}.dir@{@var{s}.dir_idx(@var{k})@}, @var{s}.file@{@var{k}@}))
## end
## @end group
## @end example
##
## @strong{Apply a file filter if needed.}
##
## @code{find_files} can take a file filter as argument, similarly to function
## @code{dir}.  For example, if don't want any other files than the files with
## extension ".c" in the @code{find_files} return structure, add a "*.c"
## argument:
##
## @example
## @group
## @var{s} = find_files (pwd, '*.c')
## @end group
## @end example
##
## An empty string argument is equivalent to not providing any file filter
## argument (i.e.@ is equivalent to no file filtering).
##
## @strong{Limit exploration depth if possible.}
##
## @code{find_files} can take a maximum exploration depth as argument.
##
## A maximum exploration depth of 1 excludes from the output structure any
## directory or file that is not directly in the explored directory.
##
## A maximum exploration depth of 2 excludes from the output structure any
## directory or file that is not directly in the explored directory or not
## directly in a subdirectory of the explored directory.
##
## And so on@dots{}
##
## Examples:
##
## @example
## @group
## @var{s} = find_files (pwd, 1)
## @end group
## @end example
##
## @example
## @group
## @var{s} = find_files (pwd, '*.c', 1)
## @end group
## @end example
##
## A zero value is equivalent to not providing any maximum exploration depth
## argument (i.e.@ a zero value does not limit the exploration depth).
##
## @strong{Ignore some directories (e.g.@ VCS directories).}
##
## The directories you want to explore with @code{find_files} may contain some
## directories that you don't want to see in the output structure.  These are
## typically directories created by some version control systems (e.g.@ Git,
## Subversion).  By default, @code{find_files} ignores the directories that are
## in the list returned by function @code{ignored_dir_list}.
##
## If you want to specify your own list of directories to be ignored, add a
## cell array argument like in the following examples:
##
## Examples:
##
## @example
## @group
## @var{s} = find_files (pwd, @{'ignored_dir_1', 'ignored_dir_2'@})
## @end group
## @end example
##
## @example
## @group
## @var{s} = find_files (pwd, 1, @{'ignored_dir_1', 'ignored_dir_2'@})
## @end group
## @end example
##
## @example
## @group
## @var{s} = find_files (pwd, '*.c', 1, @{'ignored_dir_1', 'ignored_dir_2'@})
## @end group
## @end example
##
## If you don't want any directory to be ignored, provide an empty cell array
## as argument.  Example:
##
## @example
## @group
## @var{s} = find_files (pwd, @{@})
## @end group
## @end example
##
## @strong{Use @code{find_files} iteratively with various arguments.}
##
## The usage examples provided so far demonstrate how to use @code{find_files}
## to explore one directory tree and specify eventually one file filter, one
## maximum exploration depth and one ignored directories list.
##
## You might need to explore multiple directories and use multiple file filters
## for example.  In this case, you can issue multiple calls to
## @code{find_files} providing from the second call on the output structure
## back as first argument.
##
## For example, if you need to explore two directory trees and want to exclude
## all files but those with ".c" or ".h" extension, do as follow:
##
## @example
## @group
## @var{s} = find_files ('first/directory', '*.c');
## @var{s} = find_files (@var{s}, 'first/directory', '*.h');
## @var{s} = find_files (@var{s}, 'second/directory', '*.c');
## @var{s} = find_files (@var{s}, 'second/directory', '*.h');
## @end group
## @end example
##
## Such an iterative use of @code{find_files} results in a @var{s} structure
## containing the merged results of all the directory tree explorations.
##
## Alternatively, you can use function @code{find_files_empty_s} to initialize
## an empty @code{find_files} return structure and write only one
## @code{find_files (...)} statement in a loop:
##
## @example
## @group
## @var{s} = find_files_empty_s;
## for @var{d} = @{'first/directory', 'second/directory'@}
##     for @var{f} = @{'*.c', '*.h'@}
##         @var{s} = find_files (@var{s}, d@{1@}, f@{1@});
##     end
## end
## @end group
## @end example
##
## @strong{Skip argument checking if you know that your input is safe.}
##
## @code{find_files} performs by default a check of the input structure and
## issues an error if it's not a correct @code{find_files} return structure.
## This check is superfluous for a structure that's been output by functions
## @code{find_files} or @code{find_files_empty_s} and slows down the execution
## of the function.
##
## You can instruct @code{find_files} to skip the check by providing
## explicitly all the arguments to the function and adding a supplementary
## "no_check" argument (a logical flag).  A true value for this supplementary
## argument causes @code{find_files} to skip the check.
##
## Let's rewrite the two previous examples so that the check is skipped:
##
## @example
## @group
## @var{s} = find_files ('first/directory', '*.c');
## @var{s} = find_files (@var{s}, 'first/directory', '*.h', 0, ...
##     ignored_dir_list, true);
## @var{s} = find_files (@var{s}, 'second/directory', '*.c', 0, ...
##     ignored_dir_list, true);
## @var{s} = find_files (@var{s}, 'second/directory', '*.h', 0, ...
##     ignored_dir_list, true);
## @end group
## @end example
##
## @example
## @group
## @var{s} = find_files_empty_s;
## for @var{d} = @{'first/directory', 'second/directory'@}
##     for @var{f} = @{'*.c', '*.h'@}
##         @var{s} = find_files (@var{s}, d@{1@}, f@{1@}, 0, ...
##             ignored_dir_list, true);
##     end
## end
## @end group
## @end example
##
## @seealso{absolute_path, datenum, dir, find_files_empty_s, fullfile,
## ignored_dir_list, pwd}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = find_files(varargin)

    if arg_check_needed(varargin{:})
        [s, top, f, mx, ign] = check_args(varargin{:});
    else
        [s, top, f, mx, ign] = varargin{:};
    endif

    absTop = absolute_path(top);

    if exist(absTop, 'dir')
        # The top directory exists.

        # Add the top directory to the structure (if not already done by a
        # prior call).
        dirIdx = add_dir(absTop);

        # Explore the top directory.
        [sDir, vDir, sFile, vFile, nFile] = scan_directory(absTop, f, ign);

        if nFile > 0

            z = find([s.dir_idx] == dirIdx, 1, 'last');
            if isempty(z)
                # There were no files belonging to the top directory in the
                # structure.

                append_files;
            else
                # There were files belonging to the top directory in the
                # structure.

                exclude_known_files;

                # Insert the files in the file list, just after the "legacy
                # files".
                insert_files;
            endif
        endif

        for dIdx = vDir
            absName = fullfile(absTop, sDir(dIdx).name);
            add_dir(absName);
            if mx == 0 || mx > 1
                # Recursive call.
                if mx == 0
                    newMx = 0;
                else
                    newMx = mx - 1;
                endif
                s = find_files(s, absName, f, newMx, ign, true);
            endif
        endfor
    endif

# -----------------------------------------------------------------------------

    # Add a directory to the structure if it's not already in the structure.

    function idx = add_dir(d)

        [knownDir, idx] = ismember(d, s.dir);
        if ~knownDir
            idx = numel(s.dir) + 1;
            s.dir{idx} = d;
            s.first_file_idx(idx) = 1;
            s.last_file_idx(idx) = 0;
        endif

    endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Append files to the structure.

    function append_files

        s.file = [s.file {sFile(vFile).name}];
        s.bytes = [s.bytes [sFile(vFile).bytes]];
        s.datenum = [s.datenum [sFile(vFile).datenum]];
        s.dir_idx = [s.dir_idx dirIdx * ones(1, nFile)];
        s.first_file_idx(dirIdx) = numel(s.file) + 1 - nFile;
        s.last_file_idx(dirIdx) = numel(s.file);

    endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Deselect in vFile the files that are already in the structure.

    function exclude_known_files

        newVFile = vFile;
        nFile = 0;
        for k = vFile
            if ~any(strcmp(sFile(k).name, s.file) & s.dir_idx == dirIdx)
                nFile = nFile + 1;
                newVFile(nFile) = k;
            endif
        endfor
        vFile = newVFile(1 : nFile);

    endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Insert files in the structure, just after "legacy files".

    function insert_files

        nPrev = numel(s.file);
        newZ = z + nFile;
        newN = nPrev + nFile;
        s.file(newZ + 1 : newN) = s.file(z + 1 : nPrev);
        s.file(z + 1 : newZ) = {sFile(vFile).name};
        s.bytes(newZ + 1 : newN) = s.bytes(z + 1 : nPrev);
        s.bytes(z + 1 : newZ) = [sFile(vFile).bytes];
        s.datenum(newZ + 1 : newN) = s.datenum(z + 1 : nPrev);
        s.datenum(z + 1 : newZ) = [sFile(vFile).datenum];
        s.dir_idx(newZ + 1 : newN) = s.dir_idx(z + 1 : nPrev);
        s.dir_idx(z + 1 : newZ) = dirIdx;
        k = find(s.first_file_idx > z);
        s.first_file_idx(k) = s.first_file_idx(k) + nFile;
        k = find(s.last_file_idx > z);
        s.last_file_idx(k) = s.last_file_idx(k) + nFile;
        s.last_file_idx(dirIdx) = newZ;

    endfunction

endfunction

# -----------------------------------------------------------------------------

# Return true if argument checking is needed.

function ret = arg_check_needed(varargin)

    nocheckPos = 6;
    ret = nargin < nocheckPos || ~is_logical_scalar(varargin{nocheckPos}) ...
        || ~varargin{nocheckPos};

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check the arguments.

function [s1, top, f, mx, ign] = check_args(varargin)

    if nargin > 6
        error('Too many arguments');
    endif

    needToCheckS1 = true;
    if nargin == 0
        s1 = find_files_empty_s;
        needToCheckS1 = false;
    elseif isstruct(varargin{1})
        topPos = 2;
        s1 = varargin{1};
    else
        topPos = 1;
        s1 = find_files_empty_s;
        needToCheckS1 = false;
    endif

    if nargin == 0
        top = pwd;
        k = 1;
    else
        top = varargin{topPos};
        if ~is_non_empty_string(top)
            error('Invalid top directory argument');
        endif
        k = topPos + 1;
    endif

    if needToCheckS1
        validated_mandatory_args({@is_find_files_s}, s1);
    endif

    if nargin >= k && is_string(varargin{k})
        f = varargin{k};
        k = k + 1;
    else
        f = '';
    endif

    if nargin >= k && is_integer_scalar(varargin{k})
        if varargin{k} < 0
            error('Invalid maximum depth argument');
        endif
        mx = varargin{k};
        k = k + 1;
    else
        mx = 0;
    endif

    if nargin >= k
        if ~is_cell_array_of_non_empty_strings(varargin{k}) ...
                && ~isequal(varargin{k}, {})
            error('Invalid ignored directories argument');
        endif
        ign = varargin{k};
        k = k + 1;
    else
        ign = ignored_dir_list;
    endif

    if nargin >= k && ~is_logical_scalar(varargin{k})
        error('Invalid nocheck flag');
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Use function dir with and without filter on a directory and return the
# structures returned by dir (sfile with filter, sdir without filter) as well
# as some post-processing results:
#   - vdir:  The indices of sdir corresponding to the directories except ".",
#     "..", and the ignored directories.
#   - vfile: The indices of sfile corresponding to the files.
#   - nfile: The number of files in sfile.

function [sdir, vdir, sfile, vfile, nfile] = scan_directory(dirname, filt, ign)

    sdir = dir(dirname);
    c = {sdir.name};
    vdir = find([sdir.isdir] ...
        & ~strcmp(c, '.') & ~strcmp(c, '..') & ~ismember(c, ign));
    sfile = dir(fullfile(dirname, filt));
    vfile = find(~[sfile.isdir]);
    nfile = numel(vfile);

endfunction

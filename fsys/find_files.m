## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} find_files ()
## @deftypefnx {Function File} find_files (@var{top})
## @deftypefnx {Function File} find_files (@var{top}, @var{f})
## @deftypefnx {Function File} find_files (@var{top}, @var{mx})
## @deftypefnx {Function File} find_files (@var{top}, @var{f}, @var{mx})
## @deftypefnx {Function File} find_files (@var{top}, @var{ign})
## @deftypefnx {Function File} find_files (@var{top}, @var{f}, @var{ign})
## @deftypefnx {@
## Function File} find_files (@var{top}, @var{f}, @var{mx}, @var{ign})
## @deftypefnx {Function File} find_files (@var{s}, @var{top})
## @deftypefnx {Function File} find_files (@var{s}, @var{top}, @var{f})
## @deftypefnx {Function File} find_files (@var{s}, @var{top}, @var{mx})
## @deftypefnx {@
## Function File} find_files (@var{s}, @var{top}, @var{f}, @var{mx})
## @deftypefnx {Function File} find_files (@var{s}, @var{top}, @var{ign})
## @deftypefnx {@
## Function File} find_files (@var{s}, @var{top}, @var{f}, @var{ign})
## @deftypefnx {@
## Function File} find_files (@var{top}, @var{f}, @var{mx}, @var{ign})
## @deftypefnx {@
## Function File} find_files (@var{top}, @var{f}, @var{mx}, @var{ign}, @var{@
## nocheck})
##
## Find files recursively.
##
## @code{find_files} returns a structure containing the following fields:
##
## @table @asis
## @item dir
## A cell array of strings containing the absolute path to @var{top} and the
## absolute path to every subdirectory recursively found in @var{top}, or an
## empty cell array of strings if @var{top} does not exist as a directory.  If
## @var{top} is not provided, then the working directory is used instead.  The
## directories that are in cell array of strings @var{ign} (or in the cell
## array of strings returned by @code{find_files_empty_s} if @var{ign} is not
## provided) are omitted.  If @var{mx} is provided and set to a positive
## integer value, then the subdirectories at a depth greater than @var{mx} are
## omitted.  @var{top} is at depth 1.
##
## @item file
## A cell array of strings containing the base names of the files found in the
## directories present in the "dir" field.  The files are grouped by parent
## directory.  If filter @var{f} is provided, then the files that don't match
## the filter are omitted.  Wildcards character are supported like in
## @code{dir}.  For example, you can set @var{f} to "*.m" to omit all the files
## with a name not ending with ".m".
##
## @item bytes
## A vector having the same shape as the "file" field containing the byte sizes
## of the files (similar to the "bytes" field structures returned by
## @code{dir}).
##
## @item datenum
## A vector having the same shape as the "file" field containing the timestamp
## of file modification as serial date number (similar to the "datenum" field
## structures returned by @code{dir}).  Serial date numbers are the kind of
## values returned by function @code{datenum}.
##
## @item dir_idx
## A vector having the same shape as the "file" field containing the index in
## "dir" of the directory to which the file belongs.
##
## @item first_file_idx
## A vector having the same shape as the "dir" field containing the index in
## "file" of the first file found in the directory (or 1 if no file was found
## in the directory).
##
## @item last_file_idx
## A vector having the same shape as the "dir" field containing the index in
## "file" of the last file found in the directory (or 0 if no file was found in
## the directory).
## @end table
##
## If @var{s} is provided and is a @code{find_files} return structure, then the
## information in @var{s} are included in the return structure.  This allows to
## grow the structure as many times as needed, using various @var{top},
## @var{f}, @var{mx} and @var{ign} arguments.
##
## If @var{nocheck} is provided and is true, then no argument checking is done.
##
## @seealso{datenum, dir, find_files_empty_s, ignored_dir_list}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = find_files(varargin)

    if arg_check_needed(varargin{:})
        [s1, top, f, mx, ign] = check_args(varargin{:});
    else
        [s1, top, f, mx, ign] = varargin{:};
    endif

    # Initialize the output structure.
    s = s1;

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
                s = find_files(s, absName, f, newMx, ign, false);
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

    needToCheckS1 = true;
    if nargin == 0
        s1 = find_files_empty_s;
        needToCheckS1 = false;
    elseif isstruct(varargin{1});
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

    if nargin >= k
        if ~is_positive_integer_scalar(varargin{k}) && varargin{k} ~= 0
            error('Invalid maximum depth argument');
        endif
        mx = varargin{k};
        k = k + 1;
    else
        mx = 0;
    endif

    if nargin >= k
        if ~is_cell_array_of_non_empty_strings(varargin{k})
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

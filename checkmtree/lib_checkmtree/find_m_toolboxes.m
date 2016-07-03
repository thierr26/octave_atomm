## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} find_m_toolboxes ()
## @deftypefnx {Function File} find_m_toolboxes (@var{top_str})
## @deftypefnx {Function File} find_m_toolboxes (@var{top_c})
## @deftypefnx {Function File} find_m_toolboxes (@var{top_str}, @var{ignore_p})
## @deftypefnx {Function File} find_m_toolboxes (@var{top_c}, @var{ignore_p})
##
## Find toolboxes (directories containing at least one M-file) recursively.
##
## If no argument is provided, then @code{find_m_toolboxes} searches the
## toolboxes in the working directory and its subdirectories.
##
## If a non empty string argument (@var{top_str}) is provided as first argument
## then this string is supposed to be a path to a directory and then
## @code{find_m_toolboxes} searches the toolboxes in this directory and its
## subdirectories.
##
## If a cell array of non empty strings (@var{top_c}) is given as first
## argument, then every string in the cell array is supposed to be a path to a
## directory and then @code{find_m_toolboxes} searches the toolboxes in these
## directories and their subdirectories.
##
## An optional argument @var{ignore_p} can be provided as second argument.  It
## is a logical scalar.  True means that pcode files (files with extension ".p"
## are ignored).  It defaults to false.
##
## @code{find_m_toolboxes} uses Outman for progress indication and messaging.
##
## @code{find_m_toolboxes} returns a structure containing the following fields:
##
## @table @asis
## @item toolboxpath
## Cell array of toolboxes full paths.
##
## @item depfile
## Cell array (same shape as toolboxpath field) of dependency file names (an
## empty cell means that the associated toolbox has no dependency file).
## Please see the documentation for @code{checkmtree} for more information
## about dependency files.
##
## @item privateidx
## Numerical array (same shape as toolboxpath field).  A zero value means that
## the toolbox has no private directory and a non-zero value gives the index
## associated with the toolbox in the privatemfiles field.
##
## @item mfiles
## Cell array (same shape as toolboxpath field) of cell arrays of M-file base
## names (including pcode files (files with .p extension) when no M-files with
## the same name are present in the toolbox and when run in Matlab).
##
## @item mfilebytes
## Cell array (same shape as toolboxpath field) of numerical arrays (same shape
## as the element at the same index in mfiles field) containing the byte sizes
## of the M-files.
##
## @item privatemfiles
## Similar to mfiles field, but for private directories.
##
## @item privatemfilebytes
## Similar to mfilebytes field, but for private directories.
##
## @item privatesubdir
## Always the "private" string, which is the name of the private subdirectory
## of a toolbox.
## @end table
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = find_m_toolboxes(varargin)

    [top, ignoreP] = check_args(varargin{:});
    nTop = numel(top);
    if ignoreP
        filt = m_file_filters('m_lang_only');
    else
        filt = m_file_filters;
    endif
    nFilt = numel(filt);

    oId = outman_connect_and_config_if_master;

    sFF = find_files_empty_s;
    pId = outman('init_progress', oId, 0, nTop * nFilt + 0.01, ...
        'Exploring the tree...');
    p = 0;
    for topIdx = 1 : nTop
        for filtIdx = 1 : nFilt
            sFF = find_files(sFF, top{topIdx}, filt{filtIdx});
            p = p + 1;
            outman('update_progress', oId, pId, p);
        endfor
    endfor

    mFilePresent = sFF.last_file_idx ~= 0;
    [privateDir, privateSubDir] = is_private(sFF.dir);
    isToolbox = mFilePresent & ~privateDir;
    isPrivate = mFilePresent & privateDir;
    toolboxPath = sFF.dir(isToolbox);
    nTb = numel(toolboxPath);
    mn = min([1 nTb]);

    mFiles = cell(mn, nTb);
    mFileBytes = cell(mn, nTb);
    depFile = cell(mn, nTb);
    kk = 0;
    for k = find(isToolbox)
        kk = kk + 1;
        [f, b] = remove_p_file_if_m_present(sFF, k);
        mFiles{kk} = f;
        mFileBytes{kk} = b;
        depFile{kk} = find_dep_file(sFF.dir{k});
    endfor

    privateIdx = zeros(mn, nTb);

    pI = find(isPrivate);
    kk = 0;
    for k = pI
        associatedToolbox = fileparts(sFF.dir{k});
        [flag, idx] = ismember(associatedToolbox, sFF.dir);
        if ~flag
            outman('warningf', oId, ['%s looks like a toolbox private ' ...
                'directory but the associated toolbox does not belong to ' ...
                'the analysed tree'], sFF.dir{k});
            isPrivate(k) = false;
        elseif ~isToolbox(idx)
            outman('warningf', oId, ['%s looks like a toolbox private ' ...
                'directory but the associated toolbox does not contain ' ...
                'any M-files'], sFF.dir{k});
            isPrivate(k) = false;
        else
            kk = kk + 1;
            [~, idx] = ismember(associatedToolbox, toolboxPath);
            privateIdx(idx) = kk;
            find_dep_file(sFF.dir{k}, true);
        endif
    endfor
    pI = find(isPrivate);

    nP = numel(pI);
    mn = min([1 nP]);
    privateMFiles = cell(mn, nP);
    privateMFileBytes = cell(mn, nP);
    kk = 0;
    for k = pI
        kk = kk + 1;
        [f, b] = remove_p_file_if_m_present(sFF, k);
        privateMFiles{kk} = f;
        privateMFileBytes{kk} = b;
    endfor

    outman('terminate_progress', oId, pId);
    outman('disconnect', oId);

    s = struct();
    s.toolboxpath = toolboxPath;
    s.depfile = depFile;
    s.privateidx = privateIdx;
    s.mfiles = mFiles;
    s.mfilebytes = mFileBytes;
    s.privatemfiles = privateMFiles;
    s.privatemfilebytes = privateMFileBytes;
    s.privatesubdir = privateSubDir;

endfunction

# -----------------------------------------------------------------------------

# Check the arguments.

function [top, ignore_p] = check_args(varargin)

    [top, ignore_p] = validated_opt_args(...
        {@(x) is_non_empty_string(x) ...
            || is_cell_array_of_non_empty_strings(x), pwd; ...
            @is_logical_scalar, false}, varargin{:});
    if ~iscell(top)
        top = {top};
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Extract M-file names and byte size from the find_files structure and remove
# the pcode files when a file with ".m" extension has been found.

function [f, b] = remove_p_file_if_m_present(s, k)

    keep = false(1, numel(s.file));
    keep(s.first_file_idx(k) : s.last_file_idx(k)) = true;
    for z = s.first_file_idx(k) : s.last_file_idx(k)
        [~, name, ext] = fileparts(s.file{z});
        if strcmp(ext, '.p') && ismember([name '.m'], ...
                s.file(s.first_file_idx(k) : s.last_file_idx(k)))
            keep(z) = false;
        endif
    endfor
    f = s.file(keep);
    b = s.bytes(keep);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return a logical array with the same shape as the argument (supposed to be a
# cell array of strings (absolute paths to directories)). A true value means
# that the directory is a private directory. The second output argument is the
# name of the private directories.

function [ret, private_name] = is_private(c)

    private_name = 'private';
    ret = cellfun(@(x) strcmp_name(x, private_name), c);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# True if the last component of path dir_path has no extension and is equal to
# name.

function ret = strcmp_name(dir_path, name)

    [~, nam, ext] = fileparts(dir_path);
    ret = isempty(ext) && strcmp(nam, name);

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} find_m_toolboxes ()
## @deftypefnx {Function File} {@var{s} =} find_m_toolboxes (@var{top})
## @deftypefnx {Function File} {@var{s} =} find_m_toolboxes (@var{tops})
##
## Find toolboxes recursively.
##
## @code{@var{s} = find_m_toolboxes ()} searches the current working directory
## recursively for toolboxes and returns structure @var{s} containing
## information about the content of the found toolboxes.
##
## A toolbox in this context is a directory that is not named "private" and
## that contains at least one function file.  The directory may contain a
## subdirectory named "private" containing itself one or more function files.
## Subdirectories of "private" subdirectories are entirely ignored.
##
## A function file is one of the following types of file:
##
## @itemize @bullet
## @item .m file.
##
## @item MEX file (the extension of those files differ, depending on whether
## this is Octave or Matlab running and depending on the platform).
##
## @item .oct file (only if this is Octave running).
##
## @item .p file (only if this is Matlab running).
## @end itemize
##
## The returned structure @var{s} contains the following fields:
##
## @table @asis
## @item @qcode{"toolboxpath"}
## Cell array containing the absolute paths to the found toolboxes.
##
## @item @qcode{"depfile"}
## Cell array (same shape as @qcode{"toolboxpath"} field) of dependency file
## names (an empty cell means that the corresponding toolbox has no dependency
## file).  Please see the documentation for Toolman (run @code{help toolman})
## for all the details about the dependency files.
##
## @item @qcode{"privateidx"}
## Numerical array (same shape as @qcode{"toolboxpath"} field).  A zero value
## means that the corresponding toolbox has no private directory and a non-zero
## value gives the index associated with the toolbox in the
## @qcode{"privatemfiles"} field.
##
## @item @qcode{"mfiles"}
## Cell array (same shape as @qcode{"toolboxpath"} field) of cell arrays of
## function files base names.  Note that .p files are not included if there are
## .m files with the same name in the toolbox.
##
## @item @qcode{"mfilebytes"}
## Cell array (same shape as @qcode{"toolboxpath"} field) of numerical arrays
## (same shape as the element at the same index in @qcode{"mfiles"} field)
## containing the byte sizes of the function files.
##
## @item @qcode{"privatemfiles"}
## Similar to @qcode{"mfiles"} field, but for private directories.
##
## @item @qcode{"privatemfilebytes"}
## Similar to @qcode{"mfilebytes"} field, but for private directories.
##
## @item @qcode{"privatesubdir"}
## Always the "private" string, which is the name of the private subdirectory
## of a toolbox.
## @end table
##
## If a string @var{top} is provided as argument to @code{find_m_toolboxes},
## then @code{find_m_toolboxes} searches in directory @var{top} instead of the
## current working directory.
##
## If a cell array of strings @var{tops} is provided as argument to
## @code{find_m_toolboxes}, then @code{find_m_toolboxes} searches in all
## directories given in @var{tops}.
##
## @code{find_m_toolboxes} uses outman for messaging and progress indication.
## Please run @code{help outman} for more information about Outman.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = find_m_toolboxes(varargin)

    top = check_args(varargin{:});
    nTop = numel(top);
    filt = m_file_filters;
    nFilt = numel(filt);

    oId = outman_connect_and_config_if_master;

    sFF = find_files_empty_s;
    findFilesIterCount = nTop * nFilt;
    pId = outman('init_progress', oId, 0, findFilesIterCount + 2, ...
        'Exploring the tree...');
    p = 0;
    for topIdx = 1 : nTop
        for filtIdx = 1 : nFilt
            sFF = find_files(sFF, top{topIdx}, filt{filtIdx}, 0, ...
                ignored_dir_list, true);
            p = p + 1;
            outman('update_progress', oId, pId, p);
        endfor
    endfor

    mFilePresent = sFF.last_file_idx ~= 0;
    [privateDir, privateSubDir] = is_private(sFF.dir);
    isToolbox = mFilePresent & ~privateDir;
    isPrivate = mFilePresent & privateDir;
    if any(isPrivate)
        pI = find(isPrivate);
        nP = numel(pI);
        v = find(isToolbox);
        for k = v
            kk = 1;
            while kk <= nP && isToolbox(k)
                if strncmp(sFF.dir{pI(kk)}, sFF.dir{k}, ...
                        length(sFF.dir{pI(kk)}))
                    isToolbox(k) = false;
                endif
                kk = kk + 1;
            endwhile
        endfor
        for k = pI
            kk = 1;
            while kk <= nP && isPrivate(k)
                if pI(kk) ~= k && strncmp(sFF.dir{pI(kk)}, sFF.dir{k}, ...
                        length(sFF.dir{pI(kk)}))
                    isPrivate(k) = false;
                endif
                kk = kk + 1;
            endwhile
        endfor
    endif
    toolboxPath = sFF.dir(isToolbox);
    nTb = numel(toolboxPath);
    mn = min([1 nTb]);

    mFiles = cell(mn, nTb);
    mFileBytes = cell(mn, nTb);
    depFile = cell(mn, nTb);
    kk = 0;
    v = find(isToolbox);
    n = numel(v);
    for k = v
        kk = kk + 1;
        mFiles{kk} = sFF.file(sFF.first_file_idx(k) : sFF.last_file_idx(k));
        mFileBytes{kk} ...
            = sFF.bytes(sFF.first_file_idx(k) : sFF.last_file_idx(k));
        depFile{kk} = find_dep_file(sFF.dir{k});
        outman('update_progress', oId, pId, findFilesIterCount + 2 * kk / n);
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
        privateMFiles{kk} ...
            = sFF.file(sFF.first_file_idx(k) : sFF.last_file_idx(k));
        privateMFileBytes{kk} ...
            = sFF.bytes(sFF.first_file_idx(k) : sFF.last_file_idx(k));
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

function top = check_args(varargin)

    top = validated_opt_args({@(x) is_non_empty_string(x) ...
            || is_cell_array_of_non_empty_strings(x), pwd}, varargin{:});
    if ~iscell(top)
        top = {top};
    endif

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

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} rotate_file (@var{name}, @var{byte_size_threshold})
##
## Rotate file (useful for log files).
##
## @code{rotate_file (@var{name}, @var{byte_size_threshold})} does nothing if
## @var{name} does not exist or is a file and has a byte size lower than
## @var{byte_size_threshold}.
##
## If @var{name} is a file and has a byte size greater than or equal to
## @var{byte_size_threshold}, then @code{rotate_file} renames @var{name} by
## appending ".1" to its name.  Before that, if a file with that name already
## existed, then @code{rotate_file} would have renamed the file by substituting
## ".1" with ".2".  And so on@dots{}
##
## @code{rotate_file} issues an error in the following cases:
##
## @itemize @bullet
## @item
## @var{name} is the name of a directory.
##
## @item
## One of the renaming has failed.
## @end itemize
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function rotate_file(name, byte_size_threshold)

    validated_mandatory_args(...
        {@is_non_empty_string, @is_positive_integer_scalar}, ...
        name, byte_size_threshold);

    absName = absolute_path(name);
    [dirName, baseName, Ext] = fileparts(absName);
    f = [baseName Ext];
    s = find_files(dirName, 1);

    [e, idx] = ismember(f, s.file);
    if e
        # File exists.

        byteSize = s.bytes(idx);
    else
        # File does not exist or is a directory.

        byteSize = 0;
        sD = dir(absName);
        if ~isempty(sD) && sD(1).isdir
            error('%s is a directory', name);
        endif
    endif

    if byteSize >= byte_size_threshold
        k = 1;
        while ismember([absName '.' num2str(k)], s.file);
            k = k + 1;
        endwhile
        for kk = k : -1 : 1
            target = [absName '.' num2str(kk)];
            if kk == 1
                source = absName;
            else
                source = [absName '.' num2str(kk - 1)];
            endif
            status = movefile(source, target);
            if status == 0 % movefile failed.
                error('Unable to rename file %s to %s', source, target);
            endif
        endfor
    endif

endfunction

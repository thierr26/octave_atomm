## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{path} =} home_dir ()
##
## Path to the home directory of the user.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = home_dir

    persistent retMem;

    if isempty(retMem)
        if is_octave
            retMem = get_home_directory;
        elseif ispc
            retMem = absolute_path(fullfile(getenv('HOMEDRIVE'), ...
                getenv('HOMEPATH')));
            # Applying absolute_path is usefull for the cases where HOMEPATH is
            # "\". Not applying absolute_path would cause a double backslash to
            # appear in the return value.
        else
            retMem = getenv('HOME');
        endif
    endif
    ret = retMem;

endfunction

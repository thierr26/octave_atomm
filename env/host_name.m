## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{name} =} host_name ()
##
## Name of the computer.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function nameRet = host_name

    persistent nameRetMem;

    if isempty(nameRetMem)
        if is_octave
            nameRetMem = gethostname;
        elseif ispc
            nameRetMem = getenv('COMPUTERNAME');
        else
            error('Don''t know how to get the host name');
        endif
    endif
    nameRet = nameRetMem;

endfunction

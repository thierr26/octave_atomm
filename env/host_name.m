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
        if is_octave && ~ispc
            # The ~ispc condition has been added because gethostname does not
            # seem to work on Octave for Windows (tested on Octave 4.2.0,
            # Windows 7) whereas getenv('COMPUTERNAME') yields the expected
            # result.
            nameRetMem = gethostname;
        elseif ispc
            nameRetMem = getenv('COMPUTERNAME');
        else
            error('Don''t know how to get the host name');
        endif
    endif
    nameRet = nameRetMem;

endfunction

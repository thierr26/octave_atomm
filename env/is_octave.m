## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_octave ()
##
## Return true if Octave (not Matlab) is running the function.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_octave

    persistent retMem;

    if isempty(retMem)
        retMem = exist('OCTAVE_VERSION', 'builtin') == 5;
    endif
    ret = retMem;

endfunction

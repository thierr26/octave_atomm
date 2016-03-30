## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} command_window_width ()
##
## Width (in characters) of the command window.
##
## @code{command_window_width} returns the width (in characters) of the command
## window or returns -1 if the width of the command window is unknown.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = command_window_width

    if is_octave && isunix
        [exitStatus, output] = system('tput cols');
        if exitStatus ~= 0
            ret = -1;
        else
            ret = str2double(output);
        endif
    elseif ~is_octave
        commWinSize = get(0, 'CommandWindowSize');
        ret = commWinSize(1);
    else
        ret = -1;
    endif

endfunction

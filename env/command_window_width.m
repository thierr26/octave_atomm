## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{width} =} command_window_width ()
##
## Width (in characters) of the command window.
##
## @code{@var{width} = command_window_width ()} returns in @var{width} the
## width (in characters) of the command window or returns -1 if unable to get
## the width of the command window.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function width = command_window_width

    if is_octave && isunix
        [exitStatus, output] = system('tput cols');
        if exitStatus ~= 0
            width = -1;
        else
            width = str2double(output);
        endif
    elseif ~is_octave
        commWinSize = get(0, 'CommandWindowSize');
        width = commWinSize(1);
    else
        width = -1;
    endif

endfunction

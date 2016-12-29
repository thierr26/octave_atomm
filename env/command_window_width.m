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

    if is_octave
        terminalSize = terminal_size;
        width = terminalSize(2);
    else
        commWinSize = get(0, 'CommandWindowSize');
        width = commWinSize(1);
    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} more_is_on ()
##
## True if the state of more is "on".
##
## @seealso{more}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = more_is_on

    if is_octave
        ret = page_screen_output;
    else
        ret = strcmp(get(0, 'more'), 'on');
    endif

endfunction

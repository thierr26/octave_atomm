## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} first_str_arg_pos (...)
##
## Position of the first string argument.
##
## @code{first_str_arg_pos} returns the position of the first argument that is
## a string.  If no string argument is provided, then @code{first_str_arg_pos}
## returns 0.
##
## @seealso{is_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = first_str_arg_pos(varargin)

    ret = 0;
    k = 0;
    while ret == 0 && k < nargin
        k = k + 1;
        if is_string(varargin{k})
            ret = k;
        endif
    endwhile

endfunction

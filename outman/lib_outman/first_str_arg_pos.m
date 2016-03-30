## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} first_str_arg_pos (...)
##
## Return the position of the first argument that is a string, or 0 if none of
## the arguments is a string.
##
## Function @code{is_string} is used to determine whether an argument is a
## string or not.
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

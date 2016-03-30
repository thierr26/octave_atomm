## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_uint8_col (@var{x})
##
## True for a column vector or an empty vector of type uint8.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_uint8_col(x)

    ret = (iscolumn(x) || isempty(x)) && isa(x, 'uint8');

endfunction

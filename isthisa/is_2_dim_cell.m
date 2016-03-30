## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_2_dim_cell (@var{c})
##
## True for a 2 dimensional cell array.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_2_dim_cell(c)

    ret = iscell(c) && numel(size(c)) == 2;

endfunction

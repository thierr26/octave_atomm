## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_logical_scalar (@var{x})
##
## Return true if @var{x} is logical and scalar.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_logical_scalar(x)

    ret = islogical(x) && isscalar(x);

endfunction

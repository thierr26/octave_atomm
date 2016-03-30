## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_num_scalar (@var{x})
##
## Return true if @var{x} is numeric and scalar.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_num_scalar(x)

    ret = isnumeric(x) && isscalar(x);

endfunction

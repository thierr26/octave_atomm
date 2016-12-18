## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_num_scalar (@var{x})
##
## True for a numeric scalar.
##
## @code{@var{ret} = is_num_scalar (@var{x})} returns true in @var{ret} if
## @var{x} is numeric and scalar.
##
## @seealso{isnumeric, isreal, isscalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_num_scalar(x)

    ret = isnumeric(x) && isreal(x) && isscalar(x);

endfunction

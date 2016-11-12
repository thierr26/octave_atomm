## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_logical_scalar (@var{x})
##
## True for a logical scalar.
##
## @code{@var{ret} = is_logical_scalar (@var{x})} returns true in @var{ret} if
## @var{x} is logical and scalar.
##
## @seealso{false, islogical, isscalar, true}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_logical_scalar(x)

    ret = islogical(x) && isscalar(x);

endfunction

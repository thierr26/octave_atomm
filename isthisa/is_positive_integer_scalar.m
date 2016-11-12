## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_positive_integer_scalar (@var{x})
##
## True for a positive scalar integer value.
##
## @code{@var{ret} = is_positive_integer_scalar (@var{x})} returns true in
## @var{ret} if @var{x} is an integer value, is a scalar and is greater than 0.
## @var{x} may be of an integer type or of a floating point type.
##
## @seealso{is_integer_scalar, is_natural_integer_scalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_positive_integer_scalar(x)

    ret = is_integer_scalar(x) && x > 0;

endfunction

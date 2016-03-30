## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_integer_scalar (@var{x})
##
## Return true if @var{x} is an integer value and is a scalar.  @var{x} may be
## of an integer type or of a floating point type.
##
## @seealso{is_integer_vect, is_natural_integer_scalar,
## is_positive_integer_scalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_integer_scalar(x)

    ret = is_num_scalar(x) && floor(x) == ceil(x);

endfunction

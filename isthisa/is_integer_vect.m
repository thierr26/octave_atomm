## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_integer_vect (@var{x})
##
## Return true if @var{x} is a vector of integer values.  @var{x} may be of an
## integer type or of a floating point type.
##
## @seealso{is_integer_scalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_integer_vect(x)

    ret = (isrow(x) || iscolumn(x)) && isnumeric(x) ...
        && all(floor(x) == ceil(x));

endfunction

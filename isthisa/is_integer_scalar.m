## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_integer_scalar (@var{x})
## @deftypefnx {Function File} {@var{@
## ret} =} is_integer_scalar (@var{x}, @var{tolerance})
##
## True for a scalar integer value.
##
## @code{@var{ret} = is_integer_scalar (@var{x})} returns true in @var{ret} if
## @var{x} is an integer value and is a scalar.  @var{x} may be of an integer
## type or of a floating point type.
##
## @code{@var{ret} = is_integer_scalar (@var{x}, @var{tolerance})} returns true
## in @var{ret} if the distance between @var{x} and the nearest integer is
## lower than or equal to @var{tolerance}.  The @var{tolerance} argument is
## ignored if @var{x} is not of a floating point type.
##
## @seealso{isfloat, is_integer_vect, is_natural_integer_scalar,
## is_positive_integer_scalar, isscalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_integer_scalar(x, varargin)

    ret = is_num_scalar(x);
    if isfloat(x)
        nonZeroTolerance = false;
        if nargin > 1
            tolerance = validated_opt_args({@is_num_scalar, 0}, varargin{:});
            nonZeroTolerance = tolerance > 0;
        endif
        if nonZeroTolerance
            ret = is_num_scalar(x) && abs(x - round(x)) < tolerance;
        else
            ret = is_num_scalar(x) && floor(x) == ceil(x);
        endif
    endif

endfunction

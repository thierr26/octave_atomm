## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_integer_vect (@var{x})
## @deftypefnx {Function File} {@var{ret} =} is_integer_vect (@var{x}, [@var{@
## m} @var{n}])
## @deftypefnx {Function File} {@var{ret} =} is_integer_vect (@var{x}, @var{n})
##
## True for a vector of (possibly limited) integer values.
##
## @code{@var{ret} = is_integer_vect (@var{x})} returns true in @var{ret} if
## @var{x} is a vector of integer values.  @var{x} may be of an integer type or
## of a floating point type.  In the particular case of an empty vector, a
## false value is returned.
##
## The optional argument can be used to specify a limitation on the values in
## @var{x}.  @code{is_integer_vect (@var{x}, [@var{m} @var{n}])} returns true
## only if no value in @var{x} is lower than @var{m} or greater than @var{n}.
##
## @code{is_integer_vect (@var{x}, @var{n})} is equivalent to
## @code{is_integer_vect (@var{x}, [1 @var{n}])}.
##
## One use of a call like @code{is_integer_vect(@var{x}, @var{n})} is to check
## that @var{x} contain valid indices to an array of @var{n} elements.
##
## @seealso{is_integer_scalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_integer_vect(x, varargin)

    valueCheckRequired = false;
    if nargin > 2
        error('Too many arguments');
    elseif nargin == 2
        if ~is_integer_vect(varargin{1}) || ~any(numel(varargin{1}) == [1 2])
            error(['Integer scalar or 2-component integer vector expected ' ...
                'as second argument']);
        endif
        if numel(varargin{1}) == 1
            m = 1;
            n = varargin{1};
        else
            m = varargin{1}(1);
            n = varargin{1}(2);
        endif
        valueCheckRequired = true;
    endif

    ret = isvector(x) && isnumeric(x) && isreal(x) && all(floor(x) == ceil(x));

    if ret && valueCheckRequired
        ret = all(x >= m & x <= n);
    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_integer_vect (@var{x})
## @deftypefnx {Function File} is_integer_vect (@var{x}, [@var{m} @var{n}])
## @deftypefnx {Function File} is_integer_vect (@var{x}, @var{n})
##
## Return true if @var{x} is a vector of integer values.  @var{x} may be of an
## integer type or of a floating point type.  A constraint on values in @var{x}
## can also be specified.
##
## @code{is_integer_vect([])} returns false.
##
## If a 2-component integer vector [@var{m} @var{n}] is provided as second
## argument, then @code{is_integer_vect} also performs a check of the values
## in @var{x}.  @code{is_integer_vect(@var{x}, [@var{m} @var{n}])} returns true
## if all the values in @var{x} are greater than or equal to @var{m} and lower
## than or equal to @var{n}.
##
## @code{is_integer_vect(@var{x}, @var{n})} is equivalent to
## @code{is_integer_vect(@var{x}, [1 @var{n}])}.
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

    ret = isvector(x) && isnumeric(x) && all(floor(x) == ceil(x));

    if ret && valueCheckRequired
        ret = all(x >= m & x <= n);
    endif

endfunction

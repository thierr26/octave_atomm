## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} distinct_rand (@var{a})
## @deftypefnx {Function File} distinct_rand (@var{a}, @var{max_iter})
##
## Return a random number (as returned by @code{rand(1)}) that is not already
## in numerical array @var{a}.
##
## @code{distinct_rand} raises an error if it has called @code{rand(1)}
## @var{max_iter} times and has not obtained a random number that is not
## already in @var{a}.  If @var{max_iter} is not provided, value 100 is used
## instead.
##
## @seealso{rand}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function r = distinct_rand(a, varargin)

    validated_mandatory_args({@isnumeric}, a);
    max_iter = validated_opt_args({@is_positive_integer_scalar, 100}, ...
        varargin{:});

    r = rand(1);
    k = 1;
    while ismember(r, a(:))
        if k > max_iter
            error('Unable to draw a distinct random number');
        endif
        r = rand(1);
        k = k + 1;
    endwhile

endfunction

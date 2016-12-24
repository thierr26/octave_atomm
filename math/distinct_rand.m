## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{r} =} distinct_rand (@var{a})
## @deftypefnx {Function File} {@var{r} =} distinct_rand (@var{a}, @var{@
## max_iter})
##
## Draw a random number using @code{rand} and an exclusion list.
##
## @code{@var{r} = distinct_rand (@var{a})} calls function @code{rand} until
## the returned random number is not equal to any number in numeric array
## @var{a}.  It then returns the number in @var{R}.  An error is issued if
## @code{distinct_rand} cannot return after 100 calls to @code{rand}.
##
## If you need the error to be issued after a number of calls to @code{rand}
## different than 100, you can provide the desired number as second argument
## (@var{max_iter}).
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

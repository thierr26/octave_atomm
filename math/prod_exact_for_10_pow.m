## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## ret} =} prod_exact_for_10_pow (@var{a}, @var{b})
## @deftypefnx {Function File} {@var{@
## ret} =} prod_exact_for_10_pow (@var{a}, @var{b}, @var{tolerance})
##
## Product, exact for powers of ten.
##
## @code{@var{ret} = prod_exact_for_10_pow (@var{a}, @var{b})} or
## @code{@var{ret} = prod_exact_for_10_pow (@var{a}, @var{b}, @var{tolerance})}
## returns in @var{ret} the product of @var{a} and @var{b}.  The product is
## calculated with one of the following statements:
##
## @itemize @bullet
## @item
## @code{@var{ret} = 10^(round(log10(@var{a})) + round(log10(@var{b}))} if both
## @code{log10(@var{a})} and @code{log10(@var{b})} are integers, as determined
## by @code{is_integer_scalar} called with a tolerance argument set to
## @code{1e-6} or @var{tolerance} if argument @var{tolerance} is provided.
##
## @item
## @code{@var{ret} = @var{a} * @var{b}} otherwise.
## @end itemize
##
## The point of @code{prod_exact_for_10_pow} is to make product of powers of
## ten exact.  Multiplying powers of ten with operator @code{"*"} may give
## slightly inaccurate results.
##
## @example
## @group
## isequal(1e-9 * 1e-3, 1e-12)
##    @result{} false
##
## isequal(prod_exact_for_10_pow (1e-9, 1e-3), 1e-12)
##    @result{} true
## @end group
## @end example
##
## @seealso{is_integer_scalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = prod_exact_for_10_pow(a, b, varargin)

    tolerance = validated_opt_args({@is_num_scalar, 1e-6}, varargin{:});
    done = false;
    la = log10(a);
    if is_integer_scalar(la, tolerance)
        lb = log10(b);
        if is_integer_scalar(lb, tolerance)
            ret = 10^(round(la) + round(lb));
            done = true;
        endif
    endif
    if ~done
        ret = a * b;
    endif

endfunction

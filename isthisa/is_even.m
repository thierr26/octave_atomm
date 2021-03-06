## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_even (@var{x})
##
## True if the argument is divisible by two.
##
## @code{@var{ret} = is_even (@var{x})} returns true in @var{ret} if @var{x} is
## divisible by two (i.e.@ if @code{mod(x, 2) == 0}).
##
## @seealso{mod}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_even(x)

    validated_mandatory_args(...
        {@(x) isnumeric(x) && all(~isnan(x) & ~isinf(x))}, x);
    ret = mod(x, 2) == 0;

endfunction

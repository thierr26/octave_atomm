## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_even (@var{x})
##
## True if the argument is divisible by two.
##
## @code{@var{ret} = is_even (@var{x})} returns true in @var{ret} if @var{x} is
## divisible by two (i.e.@ if @code{mod(x, 2) == 0}).  No argument checking is
## done.  If @var{x} is not of a type that is supported by @code{mod}, then an
## error is issued.
##
## @seealso{mod}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_even(x)

    validated_mandatory_args({@(x) isnumeric(x) && isreal(x)}, x);
    ret = mod(x, 2) == 0;

endfunction

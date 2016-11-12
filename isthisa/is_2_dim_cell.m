## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_2_dim_cell (@var{c})
##
## True for a 2 dimensional cell array.
##
## @code{@var{ret} = is_2_dim_cell (@var{c})} returns true in @var{ret} if
## @var{c} is a 2 dimensional cell array.
##
## Examples:
##
## @example
## @group
## is_2_dim_cell (@{@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## is_2_dim_cell (@{1, 2, 3@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## is_2_dim_cell (@{1; 2; 3@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## is_2_dim_cell (@{1, 2, 3; 4, 5, 6@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## is_2_dim_cell (@{1, 2, 3; 4, 5, 6@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## @var{c} = @{1, 2, 3; 4, 5, 6@};
## @var{c}(:, :, 2) = 0;
## is_2_dim_cell (@var{c})
##    @result{} false
## @end group
## @end example
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_2_dim_cell(c)

    ret = iscell(c) && numel(size(c)) == 2;

endfunction

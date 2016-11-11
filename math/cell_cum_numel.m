## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} cell_cum_numel (@var{c})
##
## Sum of the number of elements of the elements of a cell array.
##
## @code{@var{ret} = cell_cum_numel (@var{c})} returns in @var{ret} the sum of
## the number of elements of the elements of cell array @var{c}.
##
## Examples:
##
## @example
## @group
## cell_cum_numel (@{1, 2, 3@})
##    @result{} 3
## @end group
## @end example
##
## @example
## @group
## cell_cum_numel (@{1, [2 3], 4@})
##    @result{} 4
## @end group
## @end example
##
## @example
## @group
## cell_cum_numel (@{'ab', 'cde'@})
##    @result{} 5
## @end group
## @end example
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = cell_cum_numel(c)

    validated_mandatory_args({@iscell}, c);
    ret = sum(cellfun(@numel, c));

endfunction

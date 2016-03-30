## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} cell_cum_numel (@var{c})
##
## Sum of the number of elements of the elements of a cell array.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = cell_cum_numel(c)

    validated_mandatory_args({@iscell}, c);
    ret = sum(cellfun(@numel, c));

endfunction

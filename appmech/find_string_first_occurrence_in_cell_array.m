## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} find_string_first_occurrence_in_cell_array (@var{@
## str}, @var{c}, ...)
##
## Find the first occurrence of a string in a cell array.
##
## @code{find_string_first_occurrence_in_cell_array} returns the index of the
## first element in @var{c} that is a string and is identical to @var{str}.  If
## such element does not exist, then
## @code{find_string_first_occurrence_in_cell_array} returns 0.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = find_string_first_occurrence_in_cell_array(str, c)

    index = find(cellfun(@(x) is_string(x) && strcmp(x, str), c), 1);
    if isempty(index)
        ret = 0;
    else
        ret = index;
    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} is_cell_array_of_unique_non_empty_strings (@var{c})
##
## Return true if @var{c} is a cell array of unique non empty strings (row
## vectors of characters).
##
## @seealso{is_cell_array_of_non_empty_strings, is_non_empty_string, is_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_cell_array_of_unique_non_empty_strings(c)

    ret = is_cell_array_of_non_empty_strings(c) ...
        && numel(unique(c)) == numel(c);

endfunction
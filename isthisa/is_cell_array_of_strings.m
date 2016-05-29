## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_cell_array_of_strings (@var{c})
##
## Return true if @var{c} is a cell array of strings (row vectors of
## characters).  If @var{c} is empty, @code{is_cell_array_of_strings} returns
## true.
##
## @seealso{is_cell_array_of_non_empty_strings,
## is_cell_array_of_unique_non_empty_strings, is_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_cell_array_of_strings(c)

    ret = all(cellfun(@is_string, c(:)));

endfunction

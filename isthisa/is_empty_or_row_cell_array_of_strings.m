## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} is_empty_or_row_cell_array_of_strings (@var{c})
##
## Return true if @var{c} is an empty cell array or a row cell array of
## strings.
##
## In this context, a string is a row vector of characters.
##
## @seealso{is_cell_array_of_strings, is_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_empty_or_row_cell_array_of_strings(c)

    ret = (isempty(c) || isrow(c)) && is_cell_array_of_strings(c);

endfunction

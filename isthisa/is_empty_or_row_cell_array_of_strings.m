## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} {@var{ret} =} is_empty_or_row_cell_array_of_strings (@var{c})
##
## True for an empty or row cell array of strings.
##
## @code{@var{ret} = is_empty_or_row_cell_array_of_strings (@var{c})} returns
## true in @var{ret} if @var{c} is an empty or a row cell array of strings.
##
## In this context, a string is a row vector of characters.
##
## @seealso{is_cell_array_of_strings, is_string, is_string_list}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_empty_or_row_cell_array_of_strings(c)

    ret = (isempty(c) || isrow(c)) && is_cell_array_of_strings(c);

endfunction

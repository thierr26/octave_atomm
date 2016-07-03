## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@Function File} is_string_list (@var{c})
##
## Return true if @var{c} is an empty or row cell array of unique non empty
## strings.
##
## In this context, a string is a row vector of characters.
##
## This function could have been called
## @code{is_empty_or_row_cell_array_of_non_empty_strings} but a shorter name
## was preferred.
##
## @seealso{is_cell_array_of_non_empty_strings,
## is_cell_array_of_unique_non_empty_strings,
## is_empty_or_row_cell_array_of_strings, is_non_empty_string, is_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_string_list(c)

    ret = is_empty_or_row_cell_array_of_strings(c) ...
        && ~any(cellfun(@isempty, c(:))) ...
        && numel(unique(c)) == numel(c);

endfunction

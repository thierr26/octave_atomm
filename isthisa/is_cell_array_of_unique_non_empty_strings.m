## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## ret} =} is_cell_array_of_unique_non_empty_strings (@var{c})
##
## True for a cell array of unique non empty strings.
##
## @code{@var{ret} = is_cell_array_of_unique_non_empty_strings (@var{c})}
## returns true in @var{ret} if @var{c} is a cell array of unique non empty
## strings.  In the particular case of an empty cell array, a false value is
## returned.
##
## In this context, a string is a row vector of characters.
##
## @seealso{is_cell_array_of_non_empty_strings, is_non_empty_string,
## is_set_of_non_empty_strings, is_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_cell_array_of_unique_non_empty_strings(c)

    ret = is_cell_array_of_non_empty_strings(c) ...
        && numel(unique(c)) == numel(c);

endfunction

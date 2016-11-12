## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_cell_array_of_strings (@var{c})
##
## True for a cell array of strings.
##
## @code{@var{ret} = is_cell_array_of_strings (@var{c})} returns true in @var{@
## ret} if @var{c} is a cell array of strings.  In the particular case of an
## empty cell array, a true value is returned.
##
## In this context, a string is a row vector of characters or an empty
## character array.
##
## @seealso{is_cell_array_of_non_empty_strings,
## is_cell_array_of_unique_non_empty_strings,
## is_empty_or_row_cell_array_of_strings, is_string, is_string_list}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_cell_array_of_strings(c)

    try
        ret = all(cellfun(@is_string, c(:)));
    catch
        ret = false;
    end_try_catch

endfunction

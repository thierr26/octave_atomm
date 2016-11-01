## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## idx} =} find_string_first_occurrence_in_cell_array (@var{str}, @var{c})
##
## Find the first occurrence of a string in a cell array.
##
## @code{find_string_first_occurrence_in_cell_array} returns the index of the
## first element in @var{c} that is a string and is identical to @var{str}.  If
## such element does not exist, then
## @code{find_string_first_occurrence_in_cell_array} returns 0.
##
## @code{find_string_first_occurrence_in_cell_array} is used by the
## applications like Mental Sum@footnote{Mental Sum is a simple demonstration
## application aiming at demonstrating how the applications provided in the
## Atomm source tree (Toolman, Checkmtree and Outman) are build.  Please issue
## a @code{help mentalsum} command for all the details.} to locate the "--"
## argument (separator between command arguments and configuration arguments).
##
## @seealso{mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function idx = find_string_first_occurrence_in_cell_array(str, c)

    index = find(cellfun(@(x) is_string(x) && strcmp(x, str), c), 1);
    if isempty(index)
        idx = 0;
    else
        idx = index;
    endif

endfunction

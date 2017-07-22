## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## @var{ret} =} is_valid_phys_unit_prefix_list (@var{prefix_list})
##
## True for a valid physical unit prefixes list.
##
## @code{@var{ret} = is_valid_phys_unit_prefix_list (@var{prefix_list})}
## returns true if @var{prefix_list} can be used as argument to
## @code{phys_units_system} and @code{phys_unit_prefixes}.
##
## Please see the documentation for @code{phys_units_system} for a general
## presentation of the "physunits" toolbox.
##
## @seealso{phys_unit_prefixes, phys_units_system}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_valid_phys_unit_prefix_list(prefix_list)

    isCell = iscell(prefix_list);
    isEmpty = isCell ...
        && (isequal(prefix_list, {}) || isequal(prefix_list, cell(0, 2)));
    if isCell && ~isEmpty
        ret = size(prefix_list, 2) == 2 ...
            && is_cell_array_of_unique_non_empty_strings(prefix_list(:, 1)) ...
            && all(is_valid_phys_unit_symbol(prefix_list(:, 1))) ...
            && all(cellfun(@(x) is_num_scalar(x) && x > 0, prefix_list(:, 2)));
    else
        ret = isCell && isEmpty;
    endif

endfunction

## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_valid_phys_unit_symbol (@var{@
## unit_symbol})
##
## True for a valid physical unit symbol.
##
## @code{@var{ret} = is_valid_phys_unit_symbol (@var{unit_symbol})} returns
## true if the physical unit symbol @var{unit_symbol} is valid.  A valid
## physical unit symbol does not contain any space, dash ("-"), dot ("."),
## slash ("/") or digit character.
##
## @var{unit_symbol} can be a cell array of strings.  In this case,
## @code{is_valid_phys_unit_symbol} returns a logical array (same shape as
## @var{unit_symbol}).
##
## Please see the documentation for @code{phys_units_system} for a general
## presentation of the "physunits" toolbox.
##
## @seealso{phys_units_conv, phys_units_system}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_valid_phys_unit_symbol(unit_symbol)

    validated_mandatory_args(...
        {@(x) is_string(x) || is_cell_array_of_strings(x)}, unit_symbol);

    if iscell(unit_symbol)
        ret = true(size(unit_symbol));
        for k = 1 : numel(unit_symbol)
            ret(k) = is_non_empty_string(unit_symbol{k}) ...
                && contains_no_forbidden_characters(unit_symbol{k});
        endfor
    else
        # Recursive call.
        ret = is_valid_phys_unit_symbol({unit_symbol});
    endif

endfunction

function ret = contains_no_forbidden_characters(str)

    ret = true;
    for k = 1 : numel(str)
        if (str(k) >= '0' && str(k) <= '9') ...
                || str(k) == '/' ...
                || str(k) == '-' ...
                || str(k) == '.' ...
                || str(k) == ' '
            ret = false;
            break;
        endif
    endfor

endfunction

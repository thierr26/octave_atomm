## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{c} =} base_phys_units ()
##
## Base units of the International System of Units.
##
## @code{@var{c} = base_phys_units ()} returns a cell array of strings
## containing the symbols of the base units of the International System of
## Units.
##
## Please see the documentation for @code{phys_units_system} for a general
## presentation of the "physunits" toolbox.
##
## @seealso{phys_unit_prefixes}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function c = base_phys_units

    persistent cA;

    if isempty(cA)
        cA = {...
            'm', ...    % metre
            'kg', ...   % kilogram
            's', ...    % second
            'A', ...    % ampere
            'K', ...    % kelvin
            'mol', ...  % mole
            'cd' ...    % candela
            };
    endif

    c = cA;

endfunction

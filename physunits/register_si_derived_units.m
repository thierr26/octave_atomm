## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} register_si_derived_units (@var{s1})
##
## Register SI derived units into a physical units system structure.
##
## @code{@var{s} = register_si_derived_units (@var{s1})} returns physical units
## system structure @var{s1} in @var{s} with support for the derived units of
## the International System of Units added.
##
## Some units are not registered though: Ohm and degree Celsius.  The reason
## why they have been omitted is that there are multiple conventions for their
## symbols.  You can register them with the symbols of your choice using
## statements like:
##
## @example
## @group
## @code{@var{s} = register_phys_unit(@var{s}, 'R', [2 1 -3 -2 0 0 0]);}
## @code{@var{s} = register_phys_unit(...
##     @var{s}, 'degC', [0 0 0 0 1 0 0], 1, -273.15);}
## @end group
## @end example
##
## @code{register_si_derived_units} issues an error if the @qcode{"base_units"}
## field of @var{s1} is not identical to the return value of
## @code{base_phys_units} which would mean that the base units in @var{s1} are
## not the base units of the International System of Units.
##
## To check which units are registered in the output structure @var{s}, run
## this statement: @code{cellfun(@@disp, s.other_units(:, 1));}
##
## Please see the documentation for @code{phys_units_system} for a general
## presentation of the "physunits" toolbox.
##
## @seealso{base_phys_units, phys_units_conv, phys_units_system,
## register_phys_unit}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = register_si_derived_units(s1)

    s = check_arg(s1);

    s = register_phys_unit(s, 'rad', [ 0  0  0  0  0  0  0]); % radian
    s = register_phys_unit(s, 'sr',  [ 0  0  0  0  0  0  0]); % steradian
    s = register_phys_unit(s, 'Hz',  [ 0  0 -1  0  0  0  0]); % hertz
    s = register_phys_unit(s, 'N',   [ 1  1 -2  0  0  0  0]); % newton
    s = register_phys_unit(s, 'Pa',  [-1  1 -2  0  0  0  0]); % pascal
    s = register_phys_unit(s, 'J',   [ 2  1 -2  0  0  0  0]); % joule
    s = register_phys_unit(s, 'W',   [ 2  1 -3  0  0  0  0]); % watt
    s = register_phys_unit(s, 'C',   [ 0  1  0  1  0  0  0]); % coulomb
    s = register_phys_unit(s, 'V',   [ 2  1 -3 -1  0  0  0]); % volt
    s = register_phys_unit(s, 'F',   [-2 -1  4  2  0  0  0]); % farad
    s = register_phys_unit(s, 'S',   [-2 -1  3  2  0  0  0]); % siemens
    s = register_phys_unit(s, 'Wb',  [ 2  1 -2 -1  0  0  0]); % weber
    s = register_phys_unit(s, 'T',   [ 0  1 -2 -1  0  0  0]); % tesla
    s = register_phys_unit(s, 'H',   [ 2  1 -2 -2  0  0  0]); % henry
    s = register_phys_unit(s, 'lm',  [ 0  0  0  0  0  0  1]); % lumen
    s = register_phys_unit(s, 'lx',  [-2  0  0  0  0  0  1]); % lux
    s = register_phys_unit(s, 'Bq',  [ 0  0 -1  0  0  0  0]); % becquerel
    s = register_phys_unit(s, 'Gy',  [ 2  0 -2  0  0  0  0]); % gray
    s = register_phys_unit(s, 'Sv',  [ 2  0 -2  0  0  0  0]); % sievert
    s = register_phys_unit(s, 'kat', [ 0  0 -1  0  0  1  0]); % katal

endfunction

# -----------------------------------------------------------------------------

# Validate the input structure (checking the base units are SI base units).

function s = check_arg(s1)

    assert(isequal(s1.base_units, base_phys_units), ['Base units do not ' ...
        'seem to be the base units of the International System of Units, ' ...
        'at least not in the "right" order']);
    s = s1;

endfunction

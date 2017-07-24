## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} phys_units_system ()
## @deftypefnx {Function File} {@var{s} =} phys_units_system (@var{base_units})
## @deftypefnx {Function File} {@
## @var{s} =} phys_units_system (@var{prefix_list})
## @deftypefnx {Function File} {@
## @var{s} =} phys_units_system (@var{base_units}, @var{prefix_list})
## @deftypefnx {Function File} {@
## @var{s} =} phys_units_system (@var{prefix_list}, @var{base_units})
##
## Initialize a physical units system structure.
##
## A physical units system structure describes a physical units system.
## Functions of the "physunits" toolbox like @code{is_known_phys_unit} and
## @code{phys_units_conv} need this kind of structure to determine whether a
## particular unit is "supported" or not, whether it can be converted to
## another units and what are the appropriate conversion factor and offset.
##
## Some applications may only need support for the commonly used physical units
## and the structure returned by @code{common_phys_units_system ()} (which is
## used by default by @code{is_known_phys_unit} and @code{phys_units_conv}) may
## be suitable for such cases.  But @code{phys_units_system} (along with
## @code{register_phys_unit}) allows to build specific unit systems, including
## systems for uses other than physical units conversions (e.g.@ currency
## conversions, see example later in this documentation).
##
## So what's in a physical units system structure ? Here is a description of
## the fields of a physical units system structure:
##
## @table @asis
## @item @qcode{"base_units"}
## A row cell array of unique strings containing the symbols of the base units
## for the system.  An example of valid array for field @qcode{"base_units"} is
## the output of @code{base_phys_units ()} (base units of the International
## System of Units).  The units symbols must not contain any space, dash ("-")
## or digit characters.  You can use @code{is_valid_phys_unit_symbol} to check
## that a unit symbol is valid.  Note that a base unit can have a prefix but it
## is strongly discouraged to choose base units with prefixes except if the
## base units are the base units of the International System of Units as output
## by @code{base_phys_units ()}.  In this particular case only,
## @code{is_known_phys_unit} and @code{phys_units_conv} take special measures
## to ensure a correct handling of the "k" prefix of the "kg" base unit.  In
## all other cases, a prefix on a base unit will not be handled properly.
##
## @item @qcode{"other_units"}
## A cell array defining the other units in the system (i.e.@ the units other
## than the base units).  This cell array has four columns:
##
## @enumerate
## @item
## The symbol for the unit (a string).  The validity rules are the same as for
## the base units symbols.  You can use @code{is_valid_phys_unit_symbol} to
## check that a unit symbol is valid.  There must not be any duplicates.  As
## far as the prefixes are concerned, please not the following important
## points:
##
## @itemize @bullet
## @item
## There is no need to register in field @qcode{"other_units"} a unit which is
## already in the @qcode{"base_units"} field (with or without a prefix).  For
## example there is no need to register "g" (gram) in @qcode{"other_units"} if
## "kg" (kilogram) is in @qcode{"base_units"}.  The presence of "kg" in
## @qcode{"base_units"} ensures that "g", "mg", etc. are supported.
##
## @item
## For a unit that is not in @qcode{"base_units"} ("V" (volt) for example),
## registering "V" in @qcode{"other_units"} is enough to ensure that "V", "kV",
## "mV", etc. are supported but registering "kV" in @qcode{"other_units"}
## causes on only "kV" to be supported, not "V", "mV", etc.
## @end itemize
##
## @item
## The dimension for the unit, expressed as a row vector (same shape as field
## @qcode{"base_units"}) of integer base units exponents.  For example, if
## field @qcode{"base_units"} is
## @code{@{"m", "kg", "s", "A", "K", "mol", "cd"@}}, then the dimension for
## unit "Pa" (pascal) should be @code{[-1 1 -2 0 0 0 0]} because 1@tie{}Pa is
## 1@tie{}kg/m/s/s.  @code{[0 0 0 0 0 0 0]} is a valid dimension.  This is the
## dimension to use for example for angular units.
##
## @item
## The factor.  Let's go on with the "Pa" example.  The factor should be 1
## because 1@tie{}Pa is 1@tie{}kg/m/s/s.  Let's take now the example of unit
## "bar".  The dimension would be the same as for "Pa" but the conversion
## factor would be different: 1e5, because 1@tie{}bar is 1e5@tie{}kg/m/s/s.
##
## @item
## The offset.  Probably 0 for all units except temperature units like degree
## Celsius (factor 1 and offset -273.15 because a temperature in degree Celsius
## is the same temperature in K (Kelvin) minus 273.15) and degree Fahrenheit
## (factor @code{5 / 9} and offset -459.67 because a temperature in degree
## Fahrenheit is the result of the addition of the same temperature in K
## multiplied by @code{1 / (5 / 9)} and -459.67).
## @end enumerate
##
## @item @qcode{"prefix_list"}
## A cell array containing the supported physical unit prefixes and the
## associated factors.  This cell array has two columns:
##
## @enumerate
## @item
## The symbols for the prefixes (strings).  There must not be any duplicates.
## The validity rules are the same as for the unit symbols.
##
## @item
## The associated factors.
## @end enumerate
##
## An example of valid array for field @qcode{"prefix_list"} is the output of
## @code{phys_unit_prefixes ()}.
## @end table
##
## @code{phys_units_system} must be used to create a physical units system
## structure with fields @qcode{"base_units"} and @qcode{"prefix_list"}
## initialized.  @code{phys_units_system} leaves the @qcode{"other_units"}
## field empty (@code{cell (0, 4)}).  Use @code{register_phys_unit} and/or
## @code{register_si_derived_units} to populate @qcode{"other_units"}.
##
## When called without argument, @code{phys_units_system} returns a physical
## units system structure with field @qcode{"base_units"} set to the return
## value of @code{base_phys_units ()} and field @qcode{"prefix_list"} set to
## the return value of @code{phys_unit_prefixes ()}.
##
## If you need to create a physical units system structure with field
## @qcode{"base_units"} or @qcode{"prefix_list"} (or both) set to different
## values, provide the values as arguments to @code{phys_units_system} in any
## order.
##
## Example: Creation of a currency units system structure.
##
## The following statements create a units system structure with "USD" (United
## States Dollar) as only base unit and support for prefixes "k" (kilo), "M"
## (mega) and "G" (giga).  Then other currency units are registered: "EUR"
## (euro) and "GBP" (United Kingdom Pound). Finally functions
## @code{is_known_phys_unit} and @code{phys_units_conv}) are used to check
## support for various currency units and make conversions.
##
## @example
## @group
## @var{s} = phys_units_system (@{'USD'@}, @{'k', 1e3; 'M', 1e6; 'G', 1e9@});
##
## @var{s} = register_phys_unit (@var{s}, 'EUR', 1, 1.142);
## @var{s} = register_phys_unit (@var{s}, 'GBP', 1, 1.302);
##
## is_known_phys_unit (@var{s}, 'CAD')
##    @result{} false
##
## is_known_phys_unit (@var{s}, 'USD')
##    @result{} true
##
## is_known_phys_unit (@var{s}, 'EUR')
##    @result{} true
##
## is_known_phys_unit (@var{s}, 'GBP')
##    @result{} true
##
## phys_units_conv(@var{s}, 'kUSD', 'EUR', 2)
##    @result{} 1751.3
##
## phys_units_conv(@var{s}, 'GBP', 'EUR', 1)
##    @result{} 1.1401
## @end group
## @end example
##
## @seealso{base_phys_units, common_phys_units_system, is_known_phys_unit,
## is_valid_phys_unit_symbol, phys_unit_prefixes, phys_units_conv,
## register_phys_unit, register_si_derived_units}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = phys_units_system(varargin)

    isBaseUnits = cellfun(@isvector, varargin);
    baseUnitsArgsCount = sum(isBaseUnits);
    assert(baseUnitsArgsCount <= 1, ...
        'Please provide no more than one base units cell array argument');
    assert(nargin <= baseUnitsArgsCount + 1, ...
        'Please provide no more than one prefix list argument');

    if baseUnitsArgsCount > 0
        baseUnits = varargin{isBaseUnits};
    else
        baseUnits = base_phys_units;
    endif
    if iscolumn(baseUnits)
        baseUnits = baseUnits';
    endif
    assert(is_cell_array_of_unique_non_empty_strings(baseUnits) ...
        && all(cellfun(@is_valid_phys_unit_symbol, baseUnits)), ...
        'Invalid base units cell array');

    if nargin > baseUnitsArgsCount
        prefixList = varargin{~isBaseUnits};
    else
        prefixList = phys_unit_prefixes;
    endif
    assert(is_valid_phys_unit_prefix_list(prefixList), 'Invalid prefix list');

    s = struct(...
        'base_units', {baseUnits}, ...
        'prefix_list', {prefixList}, ...
        'other_units', {cell(0, 4)});

endfunction

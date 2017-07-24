## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} register_phys_unit (@var{@
## s1}, @var{unit_symbol}, @var{dim}, @var{factor}, @var{offset})
## @deftypefnx {Function File} {@var{s} =} register_phys_unit (@var{@
## s1}, @var{unit_symbol}, @var{dim}, @var{factor})
## @deftypefnx {Function File} {@var{s} =} register_phys_unit (@var{@
## s1}, @var{unit_symbol}, @var{dim})
##
## Register a physical unit symbol in a physical units system structure.
##
## @code{@var{s} = register_phys_unit (@var{s1}, @var{unit_symbol}, @var{dim},
## @var{factor}, @var{offset})} returns physical units system structure
## @var{s1} in @var{s} with support for unit symbol @var{unit_symbol} added.
##
## @var{dim}, @var{factor} and @var{offset} are the dimension, factor and
## offset for unit @var{unit_symbol}, as defined in the documentation for
## @code{phys_units_system} (the section about the @qcode{"other_units"} field
## of the physical units system structures).
##
## If omitted, argument @var{offset} is considered to be 0.
##
## If omitted, argument @var{factor} is considered to be 1.
##
## @seealso{phys_units_conv, phys_units_system}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = register_phys_unit(s1, unit_symbol, dim, varargin)

    s = validated_mandatory_args({...
        @isstruct, ...
        @is_valid_phys_unit_symbol, ...
        @(x) same_shape(s1.base_units, x) && is_integer_vect(x)}, ...
        s1, unit_symbol, dim);

    assert(~ismember(unit_symbol, s1.base_units), ...
        '"%s" is already a base unit', unit_symbol);
    assert(~ismember(unit_symbol, s1.other_units(:, 1)), ...
        '"%s" unit symbol is already known', unit_symbol);

    [factor, offset] = validated_opt_args(...
        {@is_num_scalar, 1; @is_num_scalar, 0}, varargin{:});

    c = {unit_symbol, dim, factor, offset};
    if isempty(s.other_units)
        s.other_units = c;
    else
        s.other_units(end + 1, :) = c;
    endif

endfunction

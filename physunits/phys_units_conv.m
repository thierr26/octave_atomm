## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{p} =} phys_units_conv (@var{@
## s}, @var{in_unit}, @var{out_unit})
## @deftypefnx {Function File} {@var{out_val} =} phys_units_conv (@var{@
## s}, @var{in_unit}, @var{out_unit}, @var{in_val})
## @deftypefnx {Function File} {@var{p} =} phys_units_conv (@var{@
## in_unit}, @var{out_unit})
## @deftypefnx {Function File} {@var{out_val} =} phys_units_conv (@var{@
## in_unit}, @var{out_unit}, @var{in_val})
##
## Physical units conversions.
##
## @code{@var{p} = phys_units_conv (@var{s}, @var{in_unit}, @var{out_unit})}
## returns in @var{p} the row vector of the coefficients of the polynomial to
## be used to compute a value in physical unit @var{out_unit} from a value in
## physical unit @var{in_unit}.  Use @code{polyval} to evaluate the polynomials
## at some specific values.  @var{s} is a physical units system structure.  If
## argument @var{s} is not provided, then the output of
## @code{common_phys_units_system} is used instead.  See documentation for
## @code{phys_units_system} for more details about physical units system
## structures.
##
## @code{@var{out_val} = phys_units_conv (@var{s}, @var{in_unit},
## @var{out_unit}, @var{in_val})} computes internally the polynomial
## coefficients and then evaluates the polynomial at the values provided in
## @var{in_val}.  The evaluation results are returned in @var{out_val}.
##
## A variety of notations are supported for unit symbols. Examples: "m", "s",
## "m/s", "m / s", "m/s/s", "m/s2", "m.s-2".  Dots can be omitted (i.e.@ you
## may use "N m" or even "Nm" instead of "N.m" for newton-metre) but you're
## encouraged to keep the dots.
##
## Note that empty or blank strings (e.g.@ @code{''}, @code{' '}) are valid
## unit symbols.  They are considered as unit symbols for dimensionless
## quantities.
##
## Example:
##
## @example
## @group
##
## % Initialize the physical units system structure.
## @var{s} = phys_units_system ();
##
## % Note that the base unit for thermodynamic temperature
## % kelvin (K).
## @var{s}.base_units
##
## % Register more units for thermodynamic temperature
## % (degree Celsius (degC) and degree Fahrenheit (degF)) to the
## % physical units system structure.
## @var{s} = register_phys_unit (@var{s}, 'degC', [0 0 0 0 1 0 0], 1, -273.15);
## @var{s} = register_phys_unit (@var{s}, 'degF', [0 0 0 0 1 0 0], ...
##     5 / 9, -459.67);
##
## % Register one more unit for time (hour (h)).
## @var{s} = register_phys_unit (@var{s}, 'h', [0 0 1 0 0 0 0], 3600);
##
## % Get the polynomial to be used to perform degF to degC
## % conversions.
## @var{poly_degf_degc} = phys_units_conv(@var{s}, 'degF', 'degC')
##    @result{} [0.55556 -17.77778]
##
## % Get the polynomial to be used to perform degC to K
## % conversions.
## @var{poly_degf_degc} = phys_units_conv(@var{s}, 'degC', 'K')
##    @result{} [1 273.15]
##
## % Perform some specific degC to degF conversions.
## @var{degf_val} = phys_units_conv(@var{s}, 'degC', 'degF', [-273.15 0 100]')
##    @result{} [-459.67; 32; 212]
##
## % Perform a km/h to m/s conversion.
## @var{speed} = phys_units_conv(@var{s}, 'km/h', 'm/s', 90)
##    @result{} 25
##
## % Space characters in unit names are automatically removed.
## @var{speed} = phys_units_conv(@var{s}, 'km / h', 'm/s', 90)
##    @result{} 25
##
## % When a unit is used in a combination of multiple units, the
## % offset is ignored.
## @var{poly_degcph_kelvinph} = phys_units_conv(@var{s}, 'degC/h', 'K/h')
##    @result{} [1 0]
## @end group
## @end example
##
## @seealso{common_phys_units_system, phys_units_system, polyval,
## register_phys_unit, register_si_derived_units}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = phys_units_conv(varargin)

    [s, in_unit, out_unit, val_provided] = check_arg_and_set_stru(varargin{:});

    [dimIn, fIn, oIn] = phys_unit_dim_factor_offset(s, in_unit);
    [dimOut, fOut, oOut] = phys_unit_dim_factor_offset(s, out_unit);
    assert(isequal(dimIn, dimOut), ...
        'Cannot perform conversion (incompatible units "%s" and "%s")', ...
        in_unit, out_unit);

    r = fIn / fOut;
    pol = [r, -(r * oIn) + oOut];

    if val_provided
        ret = polyval(pol, varargin{end});
    else
        ret = pol;
    endif

endfunction

# -----------------------------------------------------------------------------

# Check the arguments and return the physical units system structure, the
# origin unit, the destination unit and a flag indicating whether the value
# argument is provided or not.

function [s, in_unit, out_unit, val_provided] ...
        = check_arg_and_set_stru(varargin)

    assert(nargin > 1, 'At least two arguments expected');
    if isstruct(varargin{1})
        s = varargin{1};
        minExpectedNargin = 3;
    else
        s = common_phys_units_system;
        minExpectedNargin = 2;
    endif
    val_provided = is_val_arg_provided(minExpectedNargin, varargin{:});
    in_unit = varargin{minExpectedNargin - 1};
    out_unit = varargin{minExpectedNargin};

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check the argument number and return true if the value argument is provided.

function ret = is_val_arg_provided(min_expected_nargin, varargin)

    assert(any(min_expected_nargin == [nargin - 2, nargin - 1]), ...
        'Incorrect argument number.');
    ret = nargin - 2 == min_expected_nargin;

endfunction

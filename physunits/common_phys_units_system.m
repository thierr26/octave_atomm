## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} common_phys_units_system ()
## @deftypefnx {Function File} {@var{@
## s} =} common_phys_units_system (@var{prefix_list})
##
## Physical units system structure with support for common physical units.
##
## Please see the documentation for @code{phys_units_system} for a general
## presentation of the "physunits" toolbox.
##
## @code{@var{s} = common_phys_units_system ()} returns a physical units system
## structure.
##
## The base units of the system are the base units of the International
## System of Units (i.e.@ the one returned by @code{base_phys_units}).
##
## The prefix list is the one returned by @code{phys_unit_prefixes ()}.  If you
## need a different prefix list, give it as an argument to
## @code{common_phys_units_system}.  One of the following functions may
## provide a prefix list suitable for your application.  The prefix list they
## provide is the default prefix list with the micro prefix added with a
## particular symbol.
##
## @itemize @bullet
## @item
## @code{phys_unit_prefix_list_micro_extended_ascii_181};
##
## @item
## @code{phys_unit_prefix_list_micro_u03bc};
##
## @item
## @code{phys_unit_prefix_list_micro_u};
##
## @item
## @code{phys_unit_prefix_list_micro_mc};
## @end itemize
##
## The registered units are the one registered by
## @code{register_si_derived_units} and a few more:
##
## @itemize @bullet
## @item
## Common time units: min (minute), h (hour), day;
##
## @item
## l (liter);
##
## @item
## t (metric tonne);
##
## @item
## bar;
##
## @item
## turn;
##
## @item
## a (are);
##
## @item
## Common imperial units: in (inch), ft (foot), mile, lb (pound);
## @end itemize
##
## Some common units are registered because there is no universal convention
## for their symbol: Ohm, angular degree, degree Celsius and degree Fahrenheit.
## You can register them with the symbols of your choice using statements like:
##
## @example
## @group
## @code{@var{s} = register_phys_unit(@var{s}, 'R', [2 1 -3 -2 0 0 0]);}
## @code{@var{s} = register_phys_unit(...
##     @var{s}, 'deg', [0 0 0 0 0 0 0], pi / 180);}
## @code{@var{s} = register_phys_unit(...
##     @var{s}, 'degC', [0 0 0 0 1 0 0], 1, -273.15);}
## @code{@var{s} = register_phys_unit(...
##     @var{s}, 'degF', [0 0 0 0 1 0 0], 5 / 9, -459.67);}
## @end group
## @end example
##
## @seealso{base_phys_units, phys_units_conv, phys_unit_prefixes,
## phys_units_system, register_si_derived_units}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = common_phys_units_system(varargin)

    persistent s0;

    if ~isempty(s0) && nargin == 0
        s = s0;
    else
        s = compute(varargin{:});
    endif

    if isempty(s0) && nargin == 0
        s0 = s;
    endif

endfunction

# -----------------------------------------------------------------------------

# Validate the optional input argument and compute the output structure.

function s = compute(varargin)

    s = register_si_derived_units(phys_units_system(validated_opt_args(...
        {@is_valid_phys_unit_prefix_list, phys_unit_prefixes}, varargin{:})));

    mileF = 1609.344;
    poundF = 0.45359237;
    trn = 'turn';
    trnF = 2 * pi;

    s = register_phys_unit(s, 'min',  [ 0  0  1  0  0  0  0], 60);     % minute
    s = register_phys_unit(s, 'h',    [ 0  0  1  0  0  0  0], 3600);   % hour
    s = register_phys_unit(s, 'day',  [ 0  0  1  0  0  0  0], 86400);  % day
    s = register_phys_unit(s, 'l',    [ 3  0  0  0  0  0  0], 1e-3);   % liter
    s = register_phys_unit(s, 't',    [ 0  1  0  0  0  0  0], 1e3);    % tonne
    s = register_phys_unit(s, 'bar',  [-1  1 -2  0  0  0  0], 1e5);    % bar
    s = register_phys_unit(s, trn,    [ 0  0  0  0  0  0  0], trnF);   % turn
    s = register_phys_unit(s, 'a',    [ 2  0  0  0  0  0  0], 1e2);    % are
    s = register_phys_unit(s, 'in',   [ 1  0  0  0  0  0  0], 0.0254); % inch
    s = register_phys_unit(s, 'ft',   [ 1  0  0  0  0  0  0], 0.3048); % foot
    s = register_phys_unit(s, 'mile', [ 1  0  0  0  0  0  0], mileF);  % mile
    s = register_phys_unit(s, 'lb',   [ 0  1  0  0  0  0  0], poundF); % pound

endfunction

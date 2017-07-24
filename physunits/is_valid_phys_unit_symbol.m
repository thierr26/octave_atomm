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

    ret = ~is_matched_by(unit_symbol, '[0-9 \-/\.]');
    if iscell(unit_symbol)
        ret = ret & cellfun(@(x) ~isempty(x), unit_symbol);
    else
        ret = ret && ~isempty(unit_symbol);
    endif

endfunction

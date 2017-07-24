## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## @var{c} =} phys_unit_prefix_list_micro_u03bc ()
##
## Physical units prefix list, including micro prefix as U+03BC.
##
## @code{phys_unit_prefix_list_micro_u03bc ()} returns the same cell array as
## @code{phys_unit_prefixes ()} but with one more line for the micro prefix.
## The symbol for the micro prefix is U+03BC.
##
## Please see the documentation for @code{phys_units_system} for a general
## presentation of the "physunits" toolbox.
##
## @seealso{phys_unit_prefixes, phys_unit_prefix_list_micro_extended_ascii_181,
## phys_unit_prefix_list_micro_mc, phys_unit_prefix_list_micro_u}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function c = phys_unit_prefix_list_micro_u03bc

    persistent cA;

    if isempty(cA)
        cA = [phys_unit_prefixes; {char([206 188]), micro_factor}];
    endif

    c = cA;

endfunction

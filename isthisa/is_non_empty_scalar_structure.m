## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## ret} =} is_non_empty_scalar_structure (@var{s})
##
## True for a non empty scalar structure.
##
## @code{@var{ret} = is_non_empty_scalar_structure (@var{s})} returns true in
## @var{ret} if @var{s} if @var{s} is a scalar structure with at least one
## field.
##
## @seealso{isscalar, isstruct}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_non_empty_scalar_structure(s)

    ret = isstruct(s) && isscalar(s) && ~isempty(fieldnames(s));

endfunction

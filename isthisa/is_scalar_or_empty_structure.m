## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_scalar_or_empty_structure (s)
##
## True for a scalar or empty structure.
##
## @code{@var{ret} = is_scalar_or_empty_structure (@var{s}} returns true in
## @var{ret} if @var{s} is an empty or scalar structure.
##
## @seealso{isscalar, isstruct}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_scalar_or_empty_structure(s)

    ret = isstruct(s) && (isempty(s) || isscalar(s));

endfunction

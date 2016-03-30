## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_non_empty_scalar_structure (@var{s})
##
## Return true if @var{s} is a scalar structure with at least one field.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_non_empty_scalar_structure(s)

    ret = isstruct(s) && isscalar(s) && ~isempty(fieldnames(s));

endfunction

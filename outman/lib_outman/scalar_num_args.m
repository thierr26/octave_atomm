## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} scalar_num_args (...)
##
## True if zero or more numerical scalar arguments are provided.
##
## @seealso{is_num_scalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = scalar_num_args(varargin)

    ret = all(cellfun(@is_num_scalar, varargin));

endfunction

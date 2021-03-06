## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} scalar_num_arg_or_none (...)
##
## True if zero or one numerical scalar argument is provided.
##
## @seealso{is_num_scalar}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = scalar_num_arg_or_none(varargin)

    ret = nargin == 0 || (nargin == 1 && is_num_scalar(varargin{1}));

endfunction

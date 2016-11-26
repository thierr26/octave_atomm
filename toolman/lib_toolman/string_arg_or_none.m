## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} string_arg_or_none (...)
##
## True if zero or one non empty string argument is provided.
##
## @seealso{is_non_empty_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = string_arg_or_none(varargin)

    ret = nargin == 0 || (nargin == 1 && is_non_empty_string(varargin{1}));

endfunction

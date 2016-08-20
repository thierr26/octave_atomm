## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} string_arg_or_none (...)
##
## Return true if there are no argument or one argument which is a non empty
## string.
##
## @seealso{is_non_empty_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = string_arg_or_none(varargin)

    ret = nargin == 0 || (nargin == 1 && is_non_empty_string(varargin{1}));

endfunction
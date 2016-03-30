## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_printf_args (...)
##
## Return true if the arguments look like valid arguments for the "printf"
## command of @code{outman} application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_printf_args (varargin)

    k = first_str_arg_pos(varargin{:});
    ret = any(k == [1 2]) && scalar_num_arg_or_none(varargin{1 : k - 1});

endfunction

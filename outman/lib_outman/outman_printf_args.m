## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} outman_printf_args (...)
##
## True for arguments that look valid for Outman's @qcode{"printf"} command.
##
## @code{outman_printf_args} is used by Outman.  It is a very specific
## function and may not be useful for any other application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_printf_args (varargin)

    k = first_str_arg_pos(varargin{:});
    ret = any(k == [1 2]) && scalar_num_arg_or_none(varargin{1 : k - 1});

endfunction

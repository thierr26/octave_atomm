## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} outman_init_prog_args (...)
##
## True for valid arguments for Outman's @qcode{"init_progress"} command.
##
## @code{outman_init_prog_args} is used by Outman.  It is a very specific
## function and may not be useful for any other application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_init_prog_args(varargin)

    k = first_str_arg_pos(varargin{:});
    ret = any(k == [3 4]) ...
        && k == nargin && scalar_num_args(varargin{1 : end - 1});

endfunction

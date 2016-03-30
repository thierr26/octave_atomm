## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_init_prog_args (...)
##
## Return true if the arguments look like valid arguments for the
## "init_progress" command of @code{outman} application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_init_prog_args(varargin)

    k = first_str_arg_pos(varargin{:});
    ret = any(k == [3 4]) ...
        && k == nargin && scalar_num_args(varargin{1 : end - 1});

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} outman_update_prog_args (...)
##
## True for valid arguments for Outman's @qcode{"update_progress"} command.
##
## @code{outman_update_prog_args} is used by Outman.  It is a very specific
## function and may not be useful for any other application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_update_prog_args(varargin)

    ret = any(nargin == [3 5]) && scalar_num_args(varargin{:});

endfunction

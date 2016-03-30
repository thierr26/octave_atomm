## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_update_prog_args (...)
##
## Return true if the arguments look like valid arguments for the
## "update_progress" command of @code{outman} application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_update_prog_args(varargin)

    ret = any(nargin == [3 5]) && scalar_num_args(varargin{:});

endfunction

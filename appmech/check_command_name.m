## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} check_command_name (@var{s}, @var{cmd_name}, ...)
##
## Check the command name in the argument list to an application.
##
## @code{check_command_name} checks that @var{cmd_name} is a field of structure
## @var{s}.
##
## Applications like Mental Sum@footnote{Mental Sum is a simple demonstration
## application aiming at demonstrating how the applications provided in the
## Atomm source tree (Toolman, Checkmtree and Outman) are build.  Please issue
## a @code{help mentalsum} command for all the details.} use
## @code{check_command_name} to validate the command name provided by the user
## when invoking the application.
##
## @seealso{mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function check_command_name(s, varargin)

    if ~isfield(s, varargin{1})
        error('Invalid command name');
    endif

endfunction

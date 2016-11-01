## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} check_command_args (@var{s}, @var{cmdname}, ...)
##
## Check application command arguments.
##
## Applications like Mental Sum@footnote{Mental Sum is a simple demonstration
## application aiming at demonstrating how the applications provided in the
## Atomm source tree (Toolman, Checkmtree and Outman) are build.  Please issue
## a @code{help mentalsum} command for all the details.} use
## @code{check_command_args} to validate the command arguments provided by the
## user.
##
## The first argument (@var{s}) is the command structure for the application as
## returned by the application's private function
## @code{command_stru_and_default}.  @code{check_command_args} assumes it has
## been checked beforehand by @code{check_command_stru_and_default}.  Please
## see the help for @code{check_command_stru_and_default} for more information
## on the command structure.
##
## The second argument (@var{cmdname}) is the name of the command.
## @code{check_command_args} assumes it has been checked beforehand by
## @code{check_command_name}.
##
## @code{check_command_args} checks that the arguments from the third one on
## are valid with regard to the command's arguments validation function.
## If they're not valid, then an error is issued
##
## @seealso{check_command_name, check_command_stru_and_default, mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function check_command_args(s, cmdname, varargin)

    if ~s.(cmdname).valid(varargin{:})
        error('Invalid arguments for command %s', cmdname);
    endif

endfunction

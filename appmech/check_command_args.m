## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} check_command_args (@var{s}, @var{cmdname}, ...)
##
## Check application command arguments.
##
## @code{check_command_args} implements one of the mechanics used by
## applications like @code{hello} and @code{outman}: command argument checking.
##
## The first argument (@var{s}) is the "command structure" for the application.
## @code{check_command_args} assumes it has been checked beforehand by
## @code{check_command_stru_and_default}.  Please see the help for
## @code{check_command_stru_and_default} for more information on the "command
## structure".
##
## The second argument (@var{cmdname}) is the name of the command.
## @code{check_command_args} assumes it has been checked beforehand by
## @code{check_command_name}.
##
## @code{check_command_args} checks that the arguments from the third one on
## are valid with regard to the validation function for the command arguments.
## If they're not valid, then an error is raised.
##
## @seealso{check_command_name, check_command_stru_and_default, hello, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function check_command_args(s, cmdname, varargin)

    if ~s.(cmdname)(varargin{:})
        error('Invalid arguments for command %s', cmdname);
    endif

endfunction

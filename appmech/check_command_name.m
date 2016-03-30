## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} check_command_name (@var{s}, ...)
##
## Check that first argument to application is actually the name of a command
## for the application.
##
## @code{check_command_name} implements one of the mechanics used by
## applications like @code{hello} and @code{outman}: the check of the command
## name.
##
## The first argument (@var{s}) is the "command structure" for the application.
## @code{check_command_name} assumes it has been checked beforehand by
## @code{check_command_stru_and_default}.  Please see the help for
## @code{check_command_stru_and_default} for more information on the "command
## structure".
##
## The other arguments are the arguments to the application after command alias
## expansion.  @code{check_command_name} assumes that they have been output by
## @code{command_alias_expansion} which ensures that the first of these
## arguments is a non empty string.
##
## @code{check_command_name} only checks that its second argument (the first
## argument to the application) matches the name of a field of @var{s} and thus
## is a valid command name.  If it is not the case, it raises an error.
##
## @seealso{check_command_stru_and_default, command_alias_expansion, hello,
## outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function check_command_name(s, varargin)

    if ~isfield(s, varargin{1})
        error('Invalid command name');
    endif

endfunction

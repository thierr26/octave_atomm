## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} command_alias_expansion (@var{dflt_cmd}, @var{s}, ...)
##
## Perform application command alias expansion.
##
## @code{command_alias_expansion} implements one of the mechanics used by
## applications like @code{hello} and @code{outman}: command alias expansion.
##
## The first argument (@var{dflt_cmd}) is the name of the default command for
## the application.  @code{command_alias_expansion} assumes it has been checked
## using @code{check_command_stru_and_default}.
##
## The second argument (@var{s}) is the alias structure for the application.
## @code{command_alias_expansion} assumes it has been checked using
## @code{check_aliases}.  Please see the help for @code{check_aliases} for more
## information on the alias structure.
##
## The arguments from the third one on are the arguments to the application.
## If there are none, @var{dflt_cmd} is returned as the single output argument.
## If there is at least one and the first one is not the name of an alias, then
## the arguments from the third one on are returned as is.  Otherwise, the
## arguments from the third one on are returned except that the first one is
## substituted with the elements of the associated cell array in @var{s}.
##
## @seealso{check_aliases, check_command_stru_and_default, hello, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function arg = command_alias_expansion(dflt_cmd, s, varargin)

    if nargin == 2
        arg = {dflt_cmd};
    elseif ~is_non_empty_string(varargin{1})
        error('First argument must be a non empty string');
    elseif isfield(s, varargin{1})
        arg = [s.(varargin{1}) varargin(2 : end)];
    else
        arg = varargin;
    endif

endfunction

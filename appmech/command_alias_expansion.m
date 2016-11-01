## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{arg} =} command_alias_expansion (@var{@
## dflt_cmd}, @var{s}, ...)
##
## Perform application command alias expansion.
##
## @code{command_alias_expansion} processes the arguments from the third one
## on (if any) and returns a new argument array (@var{arg}).  The first two
## arguments are mandatory and are the application default command
## (@var{dflt_cmd}) and the application alias structure (@var{s}).
## @code{command_alias_expansion} assumes that the first two arguments have
## been checked beforehand by @code{check_command_stru_and_default} and
## @code{check_alias_stru} respectively.
##
## @enumerate
## @item Case where only two arguments are provided.
##
## @code{command_alias_expansion} returns a cell array with only one cell
## containing @var{dflt_cmd} (i.e.@ the name of the application default
## command).
##
## @item Case where three or more arguments are provided but the third argument
## is not a non empty string.
##
## @code{command_alias_expansion} issues an error.
##
## @item Case where the third argument is the name of a field of @var{s} (i.e.@
## the application alias structure).
##
## @code{command_alias_expansion} returns a cell array containing the arguments
## from the fourth one on preceded by the elements of the field of @var{s}
## (which is itself a cell array).
## @end enumerate
##
## Applications like Mental Sum@footnote{Mental Sum is a simple demonstration
## application aiming at demonstrating how the applications provided in the
## Atomm source tree (Toolman, Checkmtree and Outman) are build.  Please issue
## a @code{help mentalsum} command for all the details.} use
## @code{command_alias_expansion} to apply the application default command when
## no command name has been given by the user and perform alias expansion.
##
## @seealso{check_aliases, check_command_stru_and_default, mentalsum}
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

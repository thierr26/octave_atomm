## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{c} =} no_ret_val_commands (@var{@
## command_stru})
## @deftypefnx {Function File} {@var{c} =} no_ret_val_commands (@var{@
## command_stru}, @var{alias_stru})
##
## Names of the application commands that do no return anything.
##
## @code{no_ret_val_commands} takes as mandatory argument an application
## command structure @var{command_stru}.  An application alias structure can be
## provided as second argument but is not mandatory.  Please issue a
## @code{help mentalsum} command for details about the command structure and
## the alias structure of an application.
##
## @code{no_ret_val_commands} returns a cell array @var{c} containing the names
## of the applications commands (and eventually aliases) that have no output
## arguments.
##
## @seealso{apply_config_args, default_config, mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function c = no_ret_val_commands(command_stru, varargin)

    c = fieldnames(command_stru);
    keep = cellfun(@(x) command_stru.(x).no_return_value, c);
    c = c(keep)';

    if isempty(c)
        c = {};
        aName = {};
    elseif nargin > 1
        aStru = varargin{1};
        aName = fieldnames(aStru);
        keep = cellfun(@(x) ismember(aStru.(x){1}, c), aName);
        aName = aName(keep)';
        if isempty(aName)
            aName = {};
        endif
    else
        aName = {};
    endif

    c = sort([c aName]);
    if isempty(c)
        c = {};
    endif

endfunction

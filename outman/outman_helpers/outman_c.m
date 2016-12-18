## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_c (@var{condition}, @var{command}, @var{@
## caller_id}, ...)
##
## Issue an Outman command if a condition is fulfilled.
##
## @code{outman_c (@var{condition}, @var{command}, @var{caller_id}, ...)}
## runs @code{outman (@var{command}, @var{caller_id}, ...)} if @var{condition}
## is true.
##
## @var{caller_id} must have been obtained using a call to
## @code{outman_connect_and_config_if_master} or
## @code{outman_connect_and_config_if_master_c}.  In the latter case, make sure
## that the condition argument used in the call to
## @code{outman_connect_and_config_if_master_c} is weaker than the condition
## argument used in the call to @code{outman_c}.
##
## Not all Outman commands are allowed as the @var{command} argument.  Only the
## commands that do not have any output arguments have are allowed.  Those
## commands are the message displaying and logging commands as well as the
## @qcode{"update_progress"}, @qcode{"shift_progress"} and
## @qcode{"cancel_progress"} commands.
##
## Example 1:
##
## @example
## @group
## @var{verbosity} = ... # Assign a numerical value to @var{verbosity}.
## @var{id} = outman_connect_and_config_if_master;
## outman ('printf', @var{id}, 'A message');
## outman_c (@var{verbosity} > 0, 'printf', @var{id}, 'Another message');
## outman ('disconnect', @var{id});
## @end group
## @end example
##
## Example 2:
##
## @example
## @group
## @var{verbosity} = ... # Assign a numerical value to @var{verbosity}.
## @var{a} = @var{verbosity} > 1;
## @var{b} = @var{verbosity} > 0; % Note that @var{b} is weaker that @var{a}
##                    % (i.e.@ @var{a} implies @var{b}).
## @var{id} = outman_connect_and_config_if_master_c (@var{b} > 0);
## outman_c (@var{b}, 'printf', @var{id}, 'A message');
## outman_c (@var{a}, 'printf', @var{id}, 'Another message');
## outman_c (@var{b}, 'disconnect', @var{id});
## @end group
## @end example
##
## @seealso{outman, outman_connect_and_config_if_master,
## outman_connect_and_config_if_master_c}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function outman_c(condition, command, caller_id, varargin)

    persistent allowedCommands

    validated_mandatory_args(...
        {@is_logical_scalar, @is_non_empty_string, @is_num_scalar}, ...
        condition, command, caller_id);

    refreshed = false;
    if isempty(allowedCommands)
        allowedCommands = no_ret_val_commands(...
            outman_command_stru_and_default, outman_alias_stru);
        refreshed = true;
    endif

    if ~ismember(command, allowedCommands) ...
            && (refreshed || ~ismember(command, ...
                no_ret_val_commands(outman_command_stru_and_default, ...
                    outman_alias_stru)))
        error('%s cannot run Outman command or alias %s', mfilename, command);
    endif

    if condition
        outman(command, caller_id, varargin{:});
    endif

endfunction

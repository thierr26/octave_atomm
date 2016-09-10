## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{caller_id} =} outman ('connect')
## @deftypefnx {Function File} outman ('disp', @var{caller_id}, @var{x})
## @deftypefnx {Function File} outman ('dispf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('printf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('infof', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('warningf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('errorf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('logf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('logtimef', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} {@
## @var{progress_indicator_id} =} outman ('init_progress', @var{@
## caller_id}, @var{start_position}, @var{finish_position}, @var{@
## task_description_string})
## @deftypefnx {Function File} outman ('update_progress', @var{@
## caller_id}, @var{progress_indicator_id}, @var{new_position})
## @deftypefnx {Function File} outman ('update_progress', @var{@
## caller_id}, @var{progress_indicator_id}, @var{start_position}, @var{@
## finish_position}, @var{new_position})
## @deftypefnx {Function File} {@var{@
## duration} =} outman ('terminate_progress', @var{caller_id}, @var{@
## progress_indicator_id})
## @deftypefnx {Function File} outman ('cancel_progress', @var{@
## caller_id}, @var{progress_indicator_id})
## @deftypefnx {Function File} outman ('shift_progress', @var{@
## caller_id}, @var{progress_indicator_id}, @var{fractional_shift})
## @deftypefnx {Function File} {@var{@
## config} =} outman ('get_config', @var{caller_id})
## @deftypefnx {Function File} {@var{@
## config_origin} =} outman ('get_config_origin', @var{caller_id})
## @deftypefnx {Function File} {@var{@
## hmi_variant} =} outman ('get_hmi_variant', @var{caller_id})
## @deftypefnx {Function File} {@var{@
## log_file_name} =} outman ('get_log_file_name', @var{caller_id})
## @deftypefnx {Function File} outman ('disconnect', @var{caller_id})
##
## Display and log outputs, manage progress indicators.
##
## Outman stands for "OUTput MANager" and is an application aimed at being used
## as a central message displaying and logging system and as a central progress
## indicator management system.  Outman is designed based on the assumption
## that for any function using it, every function being called directly or
## indirectly by this function also uses it for displaying and logging messages
## and for managing progress indicators.  When its not the case, Outman's
## progress indicators may not be displayed properly.
##
## Currently, Outman only supports displaying to the command window, but it may
## be extended to support displaying to graphical controls.
##
## @code{demo_outman} shows what Outman can currenlty do.  Note that Outman's
## progress indicators will show up only if the use of backspace characters in
## template strings for @code{fprintf} is supported (i.e.@ if
## @code{backspace_supported} returns true).
##
## A function using Outman must at first connect to Outman and obtain a "caller
## ID".  The topmost function connecting to Outman is called the "master
## caller".  The master caller is the only caller that can setup Outman's
## configuration.  Note that the programmer writing a function that uses Outman
## does not to know whether the function will be the master caller or not.
## Actually, a function can be sometimes the master caller (if no higher level
## function has already connected to Outman) and sometimes a non master caller.
##
## Connecting to Outman and obtaining a caller ID can be done using a statement
## like one of the following:
##
## @table @asis
## @item @code{@var{caller_id} = outman('connect')}
## Connect to Outman, without attempting to change Outman's configuration.  As
## the master caller, this will configure Outman with default values for the
## configuration parameters.
##
## @item @code{@var{caller_id} = outman_connect_and_config_if_master}
## Ditto
##
## @item @code{@var{caller_id} = outman_connect_and_config_if_master(...)}
## Connect to Outman and attempt to set non default values for the
## configuration parameters.  As a non master caller, the arguments to
## @code{outman_connect_and_config_if_master} are ignored.  Please see the
## documentation for @code{outman_connect_and_config_if_master} for details on
## Outman's configuration parameters.
## @end table
##
## A function using Outman must disconnect from Outman before returning.  This
## can be done using a statement like:
##
## @code{outman('disconnect', @var{caller_id})}
##
## Between the connection and disconnection statements, the programmer can
## write Outman command statements.  They are calls to @code{outman} with a
## command name as first argument and the caller ID as second argument.  More
## arguments may be needed, depending on the command name.  The Outman command
## statements return zero or one output argument, depending on the command
## name.
##
## Outman's command can be divided into three categories:
##
## @itemize @bullet
## @item
## Message displaying and logging commands.
##
## @item
## Progress indicator management commands.
##
## @item
## Configuration getters.
## @end itemize
##
## The message displaying and logging commands are:
##
## @table @asis
## @item "disp"
## Display a variable.
##
## @item "dispf"
## Display optional arguments under the control of the template string (like
## @code{fprintf}).
##
## @item "printf"
## Display and writes to log file optional arguments under the control of the
## template string (like @code{fprintf}).
##
## @item "infof"
## Display and writes to log file optional arguments under the control of the
## template string (like @code{fprintf}), with a prefix prepended (by default
## "(I)" plus a space character).
##
## @item "warningf"
## Display and writes to log file optional arguments under the control of the
## template string (like @code{fprintf}), with a prefix prepended (by default
## "(W)" plus a space character).
##
## @item "errorf"
## Display and writes to the log file optional arguments under the control of
## the template string (like @code{fprintf}), with a prefix prepended (by
## default "(E)" plus a space character).
##
## @item "logf"
## Writes to log file optional arguments under the control of the template
## string (like @code{fprintf}).
##
## @item "logtimef"
## Writes to log file optional arguments under the control of the template
## string (like @code{fprintf}), with a timestamp prepended.
## @end table
##
## The progress indicator management commands are:
##
## @table @asis
## @item "init_progress"
## Set up a progress indicator by providing a start and a finish position (in
## arbitrary unit) as well as a string describing the task being executed.
##
## @item "update_progress"
## Update a progress indicator by providing a new start and a new finish
## position (optional) as well as the current position.
##
## @item "shift_progress"
## Update a progress indicator by providing a position percentage shift (Note:
## Progress indicator display is not updated directly by this command.
## @code{demo_outman} (more precisely the @code{subtask} private function of
## @code{demo_outman}) shows a use of the "shift progress" command: updating
## the progress indicator of a parent task).
##
## @item "terminate_progress"
## Declare a progress indicator as no more needed.  The elapsed time in days
## since the "init_progress" command is returned.
##
## @item "cancel_progress"
## Declare a progress indicator as no more needed (case of the associated task
## being interrupted before it's completed).
## @end table
##
## The configuration getters are:
##
## @table @asis
## @item "get_config"
## Get Outman's whole configuration structure (a structure where each field
## name is a configuration parameter name for Outman and the associated field
## values are the configuration parameter values).
##
## @item "get_config_origin"
## Get Outman's configuration origin structure (a structure where each field
## name is a configuration parameter name for Outman and the associated field
## values are strings indicating where the configuration parameter values come
## from).
##
## @item "get_hmi_variant"
## Get the value of Outman's "hmi_variant" configuration parameter.
##
## @item "get_log_file_name"
## Get the name of the log file (empty string if no log file).
## @end table
##
## @seealso{backspace_supported, demo_outman, fprintf,
## outman_connect_and_config_if_master, outman_kill}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = outman(varargin)

    persistent name dConf cfLocked config configOrigin cmd cmdDflt alias state;

    if isempty(cfLocked)

        name = app_name;
        # app_name is an application specific private function.

        [cmd, cmdDflt] = command_stru_and_default;
        # command_stru_and_default is an application specific private function.

        check_command_stru_and_default(cmd, cmdDflt);

        alias = alias_stru;
        # alias_stru is an application specific private function.

        check_alias_stru(cmd, alias);

        dConf = config_stru;
        # config_stru is an application specific private function.

        [config, configOrigin] = default_config(dConf, name);

        cfLocked = false;

        state = struct();
    endif

    try
        # Perform user argument checking, which may throw an error.

        arg = command_alias_expansion(cmdDflt, alias, varargin{:});
        check_command_name(cmd, arg{:});
        [cmdName, cmdArg, configArgs] = command_and_config_args(arg, cmd);
        [config, configOrigin] = apply_config_args(...
            name, dConf, config, configOrigin, cfLocked, configArgs{:});
        check_command_args(cmd, cmdName, cmdArg{:});
    catch e
        if ~cfLocked
            # Reset application persistent variables, which will allow the next
            # configuration attempt to be successful.
            clear(mfilename);
        endif
        rethrow(e);
    end_try_catch

    if cmd.(cmdName).no_return_value
        minCmdOutputArgCount = 0;
    else
        minCmdOutputArgCount = 1;
    endif
    CmdOutputArgCount = max([minCmdOutputArgCount nargout]);
    try
        [clearAppRequested, state, varargout{1 : CmdOutputArgCount}] ...
            = run_command(cmdName, cmdArg, config, configOrigin, state, ...
                nargout, name);
        commandError = false;
    catch e
        clearAppRequested = ~cfLocked;
        commandError = true;
    end_try_catch

    cfLocked = true;

    if clearAppRequested
        munlock;
        clear(mfilename);
    else
        mlock;
    endif

    if commandError
        rethrow(e);
    endif

endfunction

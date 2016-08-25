## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_connect_and_config_if_master (@var{@
## config_param_1_name}, @var{config_param_1_value}, @var{@
## config_param_2_name}, @var{config_param_2_value}, ...)
## @deftypefnx {Function File} outman_connect_and_config_if_master (@var{s})
##
## Connect to application Outman and configure if the caller is the master.
##
## @code{outman_connect_and_config_if_master} connects to Outman and configures
## it if the caller is the master (i.e.@ if @code{outman} has not been
## configured already).  The arguments are the configuration arguments to
## Outman.  They must be provided as "name-value pairs" or as a structure
## @var{s} (the names of the fields in this structure must be names of
## configuration parameters for Outman and the field values must be the
## associated values).  Arguments are ignored if the caller is not the master.
##
## @code{outman_connect_and_config_if_master} returns the caller ID.
##
## When the caller is the caller master, all configuration parameters that are
## not provided as arguments are set to their default value.  The default value
## is the "factory defined default value" (i.e.@ the default value written in
## Outman"s code) unless @code{getappdata(0, 'outman')} returns a structure
## (similar to @var{s}) with other values.
##
## The names of the configuration parameters are:
##
## @table @asis
## @item "hmi_variant"
## Type of human machine interface used by Outman (supported values:
## "command_window" (default, except when run by Matlab for Windows),
## "command_window_no_progress" (default when run on Matlab for Windows
## (it has been chosen to disable the progress indicators in the Matlab for
## Windows command window because they trigger some errors in the Matlab Java
## desktop)) and "log_file_only_if_any" (to cause Outman to no display anything
## and write only to the log file if any)).
##
## @item "logdir"
## Directory where the log file is located (user home directory by default).
##
## @item "logname"
## Name of the log file (empty by default, which means no log file).
##
## @item "log_rotation_megabyte_threshold"
## Megabyte size treshold for the rotation of the log file (10 by default).
##
## @item "log_close_ms_delay"
## Millisecond delay after which the log file is closed if no writing is done
## to the log file (works only if Outman commands are issued after writing to
## the log file, 3000ms by default).
##
## @item "progress_format"
## Progress indicator display format ("[ %msg %percent%% ]" by default).
##
## @item "progress_short_format"
## Short progress indicator display format ("[ %percent%% ]" by default).
##
## @item "progress_display_duration"
## Flag (true by default) to require the display of the task duration in
## progress indications.
##
## @item "progress_max_count"
## Maximum number of "stacked" progress indicators (3 by default).
##
## @item "progress_update_rate"
## Refresh rate (Hz) of the progress indicators display (2Hz by default).
##
## @item "progress_immediate_reshow"
## Flag (false by default if Matlab is running Outman, true by default
## otherwise) to require an immediate reshow of the progress indicator after
## the display of a message.
##
## @item "progress_file_name"
## Name of the progress indicator file (one line text file to which Outman
## writes progress indication) (empty by default (an empty value means that
## there is no progress indicator file)).
##
## @item "progress_file_update_rate"
## Refresh rate (Hz) of the progress indicator file (0.33 Hz by default).
##
## @item "info_leader"
## Prefix used in errorf commands ("(I)" plus a space character by default).
##
## @item "warning_leader"
## Prefix used in errorf commands ("(W)" plus a space character by default).
##
## @item "error_leader"
## Prefix used in errorf commands ("(E)" plus a space character by default).
##
## @item "min_width_for_word_wrapping"
## Window width thresholds (in characters) to apply word wrapping in "dispf",
## "printf", "infof", "errorf", "printf" commands (50 by default).
## @end table
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [caller_id, master] = outman_connect_and_config_if_master(varargin)

    master = ~mislocked('outman');
    if master
        # Start and configure Outman.
        [~, caller_id] = outman('configure', '--', varargin{:});
    else
        # Connect to Outman without attempting to configure it (which would
        # cause an error).
        caller_id = outman('connect');
    endif

endfunction

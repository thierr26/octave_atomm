## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_o (@var{command}, ...)
## @deftypefnx {Function File} outman_o (@var{condition}, @var{command}, ...)
##
## Connect to Outman, issue an Outman command and disconnect from outman.
##
## @code{outman_o (@var{command}, ...)} runs Outman command @var{command}.
## Arguments from the second one on (if any) are passed as the Outman command
## arguments.  @code{outman_o} takes care of connecting to and disconnecting
## from Outman.  There is no attempt to specify any Outman configuration
## parameters, so if the caller of @code{outman_o} is Outman's master caller,
## then Outman is started up with its default configuration.
##
## Not all Outman commands are allowed as the @var{command} argument.  Only the
## message displaying and logging commands are allowed as well as the
## @qcode{"update_progress"}, @qcode{"shift_progress"} and
## @qcode{"cancel_progress"} commands.
##
## @code{outman_o} is especially useful to write scripts that don't alter the
## workspace, since you don't need to assign the Outman caller ID to a
## variable.
##
## @code{outman_o (@var{condition}, @var{command}, ...)} does the same as
## @code{outman_o (@var{command}, ...)} if @var{condition} is true and does
## nothing if @var{condition} is false.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function outman_o(varargin)

    if is_logical_scalar(varargin{1})
        optArgin = cell(1, numel(varargin) - 2);
    else
        optArgin = cell(1, numel(varargin) - 1);
    endif
    [condition, command, optArgin{:}] = deal_args(varargin{:});
    oId = outman_connect_and_config_if_master_c(condition);
    outman_c(condition, command, oId, optArgin{:});
    outman_c(condition, 'disconnect', oId);

endfunction

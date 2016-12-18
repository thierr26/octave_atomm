## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_log_task_start_time (@var{@
## caller_id}, @var{task_name})
## @deftypefnx {Function File} outman_log_task_start_time (@var{@
## condition}, @var{caller_id}, @var{task_name})
##
## Log the start time of a task.
##
## @code{outman_log_task_start_time (@var{caller_id}, @var{task_name})} runs
## the following Outman command:
##
## @example
## @group
## outman('logtimef', @var{caller_id}, '%s starts', @var{task_name});
## @end group
## @end example
##
## For example, @code{outman_log_task_start_time} and
## @code{outman_log_task_done_time} may be used to log the start and finish
## times of a function:
##
## @example
## @group
## function my_function
##     @var{oid} = outman_connect_and_config_if_master;
##     outman_log_task_start_time (@var{oid}, mfilename);
##     ... % Function's job done here.
##     outman_log_task_done_time (@var{oid}, mfilename);
##     outman('disconnect', @var{oid});
## end
## @end group
## @end example
##
## Of course you must handle exceptions that may be issued during the
## function's job and make sure the function disconnects from Outman even if
## the job is not completed.
##
## Please read Outman's documentation for all the details (@code{help outman}).
##
## @code{outman_log_task_start_time (@var{condition}, @var{caller_id},
## @var{task_name})} does the same as
## @code{outman_log_task_start_time (@var{caller_id}, @var{task_name})} if
## the logical scalar @var{condition} is true or does nothing if it is false.
##
## @seealso{mfilename, outman, outman_log_task_done_time}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function outman_log_task_start_time(varargin)

    [condition, caller_id, task_name] = deal_args(varargin{:});
    outman_c(condition, 'logtimef', caller_id, '%s starts\n', task_name);

endfunction

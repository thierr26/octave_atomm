## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_log_task_done_time (@var{@
## caller_id}, @var{task_name})
## @deftypefnx {Function File} outman_log_task_done_time (@var{@
## condition}, @var{caller_id}, @var{task_name})
##
## Log the finish time of a task.
##
## @code{outman_log_task_done_time (@var{caller_id}, @var{task_name})} runs
## the following Outman command:
##
## @example
## @group
## outman('logtimef', @var{caller_id}, '%s done', @var{task_name});
## @end group
## @end example
##
## Please read the documentation for @code{outman_log_task_start_time} for an
## example of use of @code{outman_log_task_done_time}.
##
## @code{outman_log_task_done_time (@var{condition}, @var{caller_id},
## @var{task_name})} does the same as
## @code{outman_log_task_done_time (@var{caller_id}, @var{task_name})} if
## the logical scalar @var{condition} is true or does nothing if it is false.
##
## @seealso{mfilename, outman, outman_log_task_start_time}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function outman_log_task_done_time(varargin)

    [condition, caller_id, task_name] = deal_args(varargin{:});
    outman_c(condition, 'logtimef', caller_id, '%s done\n', task_name);

endfunction

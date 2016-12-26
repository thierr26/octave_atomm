## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_log_and_error (@var{caller_id}, @var{@
## task_name}, @var{template}, ...)
## @deftypefnx {Function File} outman_log_and_error (@var{condition}, @var{@
## caller_id}, @var{task_name}, @var{template}, ...)
##
## Log with time stamp, then issue a, error.
##
## @code{outman_log_and_error (@var{caller_id}, @var{task_name}, @var{@
## template}, ...)} runs the following commands:
##
## @example
## @group
## outman('logtimef', @var{caller_id}, 'Error in %s', @var{task_name});
## error(@var{template}, ...)
## @end group
## @end example
##
## Note that the @code{error} statement is issued without disconnecting from
## Outman.  It is the programmer's responsibility to catch the error,
## disconnect from Outman and rethrow the error.
## @code{outman_disconnect_and_rethrow} can be used for that, like in this
## example:
##
## @example
## @group
## function my_function
##     @var{caller_id} = outman_connect_and_config_if_master;
##     ...
##     try
##         ...
##         if ...
##             outman_log_and_error(...
##                 @var{caller_id}, mfilename, 'Error message');
##         end
##         ...
##     catch @var{err}
##         outman_disconnect_and_rethrow(@var{caller_id}, @var{err});
##     end
##     ...
##     outman('disconnect', @var{caller_id});
## end
## @end group
## @end example
##
## @code{outman_disconnect_and_rethrow} displays and logs the error message
## before disconnecting from Outman and rethrowing the error.
##
## For more information about outman, please issue a @code{help outman}
## statement.
##
## @code{outman_log_and_error (@var{condition}, @var{caller_id}, @var{@
## task_name}, @var{template}, ...)} does the same as
## @code{outman_log_and_error (@var{caller_id}, @var{task_name}, @var{@
## template}, ...)} if the logical scalar @var{condition} is true or does not
## run the @code{outman('logtimef', ...)} command if it is false.
##
## @seealso{mfilename, outman, outman_connect_and_config_if_master,
## outman_disconnect_and_rethrow}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function outman_log_and_error(varargin)

    if is_logical_scalar(varargin{1})
        optArgin = cell(1, numel(varargin) - 3);
    else
        optArgin = cell(1, numel(varargin) - 2);
    endif
    [condition, caller_id, task_name, optArgin{:}] = deal_args(varargin{:});
    outman_c(condition, 'logtimef', caller_id, 'Error in %s', task_name);
    error(optArgin{:});

endfunction

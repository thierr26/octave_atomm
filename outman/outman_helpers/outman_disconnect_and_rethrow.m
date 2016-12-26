## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_disconnect_and_rethrow (@var{@
## caller_id}, @var{err})
## @deftypefnx {Function File} outman_disconnect_and_rethrow (@var{@
## condition}, @var{caller_id}, @var{err})
##
## Disconnect from Outman and rethrow an error.
##
## @code{outman_disconnect_and_rethrow (@var{caller_id}, @var{err})} runs
## the following commands:
##
## @example
## @group
## outman('errorf', @var{caller_id}, '%s', @var{err}.message);
## outman('disconnect', @var{caller_id});
## rethrow(@var{err});
## @end group
## @end example
##
## Please read the documentation for @code{outman_log_and_error} for an example
## of use of @code{outman_disconnect_and_rethrow}.
##
## @code{outman_disconnect_and_rethrow (@var{condition}, @var{@
## caller_id}, @var{err})} does the same as
## @code{outman_disconnect_and_rethrow (@var{caller_id}, @var{err})} if the
## logical scalar @var{condition} is true or does not run the
## @code{outman('errorf', ...)} and @code{outman('disconnect', ...)} commands
## if it is false.
##
## @seealso{mfilename, outman, outman_log_and_error}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function outman_disconnect_and_rethrow(varargin)

    [condition, caller_id, err] = deal_args(varargin{:});
    outman_c(condition, 'errorf', caller_id, '%s', err.message);
    outman_c(condition, 'disconnect', caller_id);
    rethrow(err);

endfunction

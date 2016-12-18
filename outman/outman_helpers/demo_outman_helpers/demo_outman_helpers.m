## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} demo_outman_helpers (@var{verbosity}, @var{@
## err}, @var{outman_config_param_1_name}, @var{@
## outman_config_param_1_value}, @var{outman_config_param_2_name}, @var{@
## outman_config_param_2_value}, ...)
## @deftypefnx {Function File} demo_outman_helpers (@var{verbosity}, @var{@
## err}, @var{stru})
##
## Example use for the functions of the "outman_helpers" toolbox.
##
## @code{demo_outman_helpers} takes two mandatory arguments:
##
## @table @asis
## @item @var{verbosity}
## An integer scalar from 0 to 2: 0 means nothing displayed and nothing logged,
## 1 means "normal" display and logging, 2 means more messages displayed.
##
## @item @var{err}
## A logical scalar: false causes @code{demo_outman_helpers} to complete
## without issuing any error, true causes @code{demo_outman_helpers} to issue
## an error while doing its job.
## @end table
##
## If no more arguments are provided, then @code{demo_outman_helpers} uses
## Outman with its default configuration parameters.  To cause
## @code{demo_outman_helpers} to use Outman with non default configuration
## parameters, provide them as name-value pairs arguments or as a structure
## argument.  Examples:
##
## @example
## @group
## demo_outman_helpers(...
##     'logdir', 'path/to/log/file', 'logname', 'demo_outman_helpers.log');
## @end group
## @end example
##
## @example
## @group
## demo_outman_helpers(struct(...
##     'logdir', 'path/to/log/file', 'logname', 'demo_outman_helpers.log'));
## @end group
## @end example
##
## Outman usage and configuration is fully documented in the help for Outman.
## Please issue a @code{help outman} command to read it.
##
## Note that Outman's progress indicators may not show up, depending on
## Outman's configuration.  For example, when run by Matlab for windows,
## Outman's default configuration is to not show the progress indicators.
##
## @seealso{outman, outman_c, outman_connect_and_config_if_master_c,
## outman_disconnect_and_rethrow, outman_log_and_error,
## outman_log_task_done_time, outman_log_task_start_time}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function demo_outman_helpers(verbosity, err, varargin)

    validated_mandatory_args(...
        {@(x) is_num_scalar(x) && any(x == 0 : 2), @is_logical_scalar}, ...
        verbosity, err);

    oId = outman_connect_and_config_if_master_c(verbosity > 0, varargin{:});
    outman_log_task_start_time(verbosity > 0, oId, mfilename);

    outman_c(verbosity > 0, 'dispf', oId, 'Let''s enter a loop...');
    n = 10;
    if verbosity > 0
        pId = outman('init_progress', oId, 0, n, 'Looping...');
    else
        pId = -1;
    endif

    for k = 1 : n

        try
            pause(0.8);
            outman_c(verbosity > 1, 'dispf', oId, 'Iteration #%d', k);
            if err && k == round(n * 0.66);
                outman_log_and_error(verbosity > 0, oId, mfilename, ...
                    'Error issued by %s as required by user', mfilename);
            endif
            outman_c(verbosity > 0, 'update_progress', oId, pId, k);
        catch e
            outman_c(verbosity > 0, 'cancel_progress', oId, pId);
            outman_disconnect_and_rethrow(verbosity > 0, oId, e);
        end_try_catch

    endfor

    if verbosity > 0
        dura = outman('terminate_progress', oId, pId);
        outman('printf', oId, 'Looping took %s', duration_str(dura));
    endif
    outman_log_task_done_time(verbosity > 0, oId, mfilename);
    outman_c(verbosity > 0, 'disconnect', oId);

endfunction

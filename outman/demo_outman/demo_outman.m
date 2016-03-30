## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} demo_outman ()
## @deftypefnx {Function File} demo_outman (@var{logdir})
## @deftypefnx {Function File} demo_outman (@var{logdir}, @var{logname})
##
## Demonstrate what @code{outman} can do.
##
## If no argument is provided, then @code{demo_outman} does not write to any
## log file.  If @var{logdir} (first argument) is provided, then
## @code{demo_outman} writes to log file demo_outman.log in directory
## @var{logdir}.  if @var{logname} (second argument) is also provided, then
## @code{demo_outman} writes to log file @var{logname} in directory
## @var{logdir}.
##
## If @var{logdir} is an empty string, then the log file is written to the
## current working directory.
##
## You can run @code{demo_outman} in narrow or large command windows to see the
## beahvior difference.
##
## Note that Outman's progress indicators will show up only if the use of
## backspace characters in template strings for @code{fprintf} is supported
## (i.e. if @code{backspace_supported} returns true).
##
## @seealso{backspace_supported, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function demo_outman(varargin)

    [logdir, logname] = validated_opt_args(...
        {@is_string, ''; ...
        @is_non_empty_string, 'demo_outman.log'}, varargin{:});

    oName = 'Outman';

    if nargin > 0
        alreadyConfigured = mislocked('outman');
        oId = outman_connect_and_config_if_master(...
            'logdir', logdir, 'logname', logname);
        outman('logtimef', oId, '%s started', mfilename);
        if alreadyConfigured
            outman('infof', oId, ['%s was already configured. The log ' ...
                'file may not be the one you expect, or there may be ' ...
                'no log file.'], oName);
        endif
    else
        oId = outman_connect_and_config_if_master;
    endif
    cf = outman('get_config', oId);
    logFile = outman('get_log_file_name', oId);
    oCName = 'outman_connect_and_config_if_master';
    if isempty(logFile)
        outman('dispf', oId, ...
            '%s now connected to %s using %s function. No log file.\n', ...
            mfilename, oName, oCName);
    else
        outman('dispf', oId, ...
            '%s now connected to %s using %s function. Log file is %s.\n', ...
            mfilename, oName, oCName, logFile);
    endif

    outman('dispf', oId, '%s command "disp" displays a variable.', oName);
    outman('dispf', oId, 'Example with a magic square:');
    outman('disp', oId, magic(4));
    outman('dispf', oId, '');

    outman('dispf', oId, ['%s command "dispf" displays a formatted output ' ...
        '(like fprintf).\n'], oName);

    outman('dispf', oId, ['The following %s commands do the same, except ' ...
        'that they also write to the log file (if any):'], oName);
    outman('dispf', oId, '- "printf"');
    outman('dispf', oId, '- "errorf"');
    outman('dispf', oId, '- "warningf"');
    outman('dispf', oId, '- "infof"\n');

    outman('dispf', oId, ['With "errorf", "warningf" and "infof" a prefix ' ...
        'is prepended (resp. "%s", "%s" and "%s" plus a space ' ...
        'character).\n'], ...
        strtrim(cf.error_leader), strtrim(cf.warning_leader), ...
        strtrim(cf.info_leader));

    outman('dispf', oId, ['%s command "logf" writes a formatted output to ' ...
        'the log file (if any).\n'], oName);
    outman('logf', oId, ['This message is written only to the log file ' ...
        'using command "logf".']);

    outman('dispf', oId, ['Let''s setup a progress indicator using the %s ' ...
        'command "init_progress" and start a long task...\n'], oName);
    n1 = 400;
    pId = outman('init_progress', oId, 0, n1, 'Long task in progress...');
    t11 = floor(2 * n1 / 7);
    t12 = 2 * t11;
    t13 = 3 * t11;
    for k1 = 1 : n1
        slowfunc;
        if k1 == t11
            outman('dispf', oId, ['The various %s ouput commands can be ' ...
                'used by the task without "overwritting" the progress ' ...
                'indication.\n'], oName);
        endif
        if k1 == t12
            outman('dispf', oId, ['The %s command "update_progress" is ' ...
                'used to update the progress indicator.\n'], oName);
        endif
        if k1 == t13
            outman('dispf', oId, ['Almost done... The %s command ' ...
                '"terminate_progress" will be used to dispose of the ' ...
                'progress indicator.\n'], oName);
        endif
        outman('update_progress', oId, pId, k1);
    endfor
    dura = outman('terminate_progress', oId, pId);
    outman('dispf', oId, 'Task took %s to complete.\n', duration_str(dura));

    outman('dispf', oId, 'Let''s start another long task.\n');
    n2 = 200;
    pId = outman('init_progress', oId, 0, n1 + n2, 'Main task in progress...');
    for k1 = 1 : n1
        slowfunc;
        if k1 < t12
            p = k1;
        elseif k1 == t12
            p = k1;
            subtask(n2, false, @slowfunc, oName, pId);
        else
            p = k1 + n2;
        endif
        outman('update_progress', oId, pId, p);
    endfor
    outman('terminate_progress', oId, pId);

    outman('dispf', oId, 'Let''s restart the same long task.\n');
    pId = outman('init_progress', oId, 0, n1 + n2, 'Main task');
    for k1 = 1 : n1
        slowfunc;
        if k1 == t11
            outman('dispf', oId, ['This time, the subtask will be ' ...
                'canceled before it is completed.\n'], oName);
            p = k1;
        elseif k1 < t12
            p = k1;
        elseif k1 == t12
            p = k1;
            subtask(n2, true, @slowfunc, oName, pId);
        else
            p = k1 + n2;
        endif
        outman('update_progress', oId, pId, p);
    endfor
    outman('terminate_progress', oId, pId);

    outman('dispf', oId, ['%s will now disconnect from %s. End of the ' ...
        'demonstration.'], mfilename, oName);
    outman('logtimef', oId, '%s done', mfilename);
    outman('disconnect', oId);

endfunction

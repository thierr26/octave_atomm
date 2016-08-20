## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function [clear_req, s, varargout] = run_command(c, cargs, cf, o, s1, ~, ~)

    clear_req = false;
    s = setup_log_file_full_name(s1, cf);
    s = setup_cmd_win_prog_warn_needed(s, cf);
    [s, callerID] = get_caller_id(s, c, cargs);

    switch c

        case 'quit'
            clear_req = is_master(s, callerID);
            if clear_req
                s = cancel_all_progress(s, cf);
                s = close_log_file(s);
            endif
            [~, idx] = ismember(callerID, s.caller_id);
            s.caller_id(idx) = [];

        case 'configure'
            varargout{1} = cf;
            varargout{2} = callerID;

        case 'connect'
            varargout{1} = callerID;

        case 'disp'
            s = echo(s, cf, false, false, cargs{end});

        case 'dispf'
            a = first_non_id_arg_idx(cargs);
            s = echo(s, cf, false, true, sprintf(cargs{a : end}));

        case 'printf'
            a = first_non_id_arg_idx(cargs);
            s = echo(s, cf, true, true, sprintf(cargs{a : end}));

        case 'errorf'
            a = first_non_id_arg_idx(cargs);
            s = echo(s, cf, true, true, ...
                sprintf([cf.error_leader cargs{a}], cargs{a + 1 : end}));

        case 'warningf'
            a = first_non_id_arg_idx(cargs);
            s = echo(s, cf, true, true, ...
                sprintf([cf.warning_leader cargs{a}], cargs{a + 1 : end}));

        case 'infof'
            a = first_non_id_arg_idx(cargs);
            s = echo(s, cf, true, true, ...
                sprintf([cf.info_leader cargs{a}], cargs{a + 1 : end}));

        case 'logf'
            a = first_non_id_arg_idx(cargs);
            s = write_to_log_file(s, cf, sprintf(cargs{a : end}));

        case 'logtimef'
            a = first_non_id_arg_idx(cargs);
            s = write_to_log_file(...
                s, cf, sprintf([timestamp ' ' cargs{a}], cargs{a + 1 : end}));

        case 'init_progress'
            [s, progressID] ...
                = create_new_progress_if_max_count_not_reached(s, cf, cargs);
            varargout{1} = progressID;
            return_caller_id_if_required(nargout, 2);

        case 'update_progress'
            s = update_progress(s, cf, cargs);

        case 'shift_progress'
            s = shift_progress(s, cargs);

        case 'terminate_progress'
            [s, duration] = terminate_progress(s, cf, cargs);
            varargout{1} = duration;

        case 'cancel_progress'
            s = cancel_progress(s, cf, cargs);

        case 'get_config'
            varargout{1} = cf;
            return_caller_id_if_required(nargout, 2);

        case 'get_config_origin'
            varargout{1} = o;
            return_caller_id_if_required(nargout, 2);

        case 'get_hmi_variant'
            varargout{1} = cf.hmi_variant;
            return_caller_id_if_required(nargout, 2);

        case 'get_log_file_name'
            if isfield(s, 'logfile')
                varargout{1} = s.logfile.fullname;
            else
                varargout{1} = '';
            endif
            return_caller_id_if_required(nargout, 2);

        otherwise
            error('Internal error: Command %s not handled', c);

    endswitch

    s = close_log_file_if_delay_expired(s, cf);

# -----------------------------------------------------------------------------

    # Return caller ID if user has specified enough output arguments.

    function return_caller_id_if_required(n_output_arg, varargoutpos)

        if n_output_arg >= varargoutpos + 2
            varargout{varargoutpos} = callerID;
        endif

    endfunction

endfunction

# -----------------------------------------------------------------------------

# Get (if already determined) or compute caller ID.

function [s, id] = get_caller_id(s1, c, cargs)

    s = s1;
    fieldCreationNeeded = ~isfield(s1, 'caller_id');
    newIDNeeded = fieldCreationNeeded || strcmp(c, 'connect');
    if ~newIDNeeded && (numel(cargs) == 0 ...
            || (strcmp(c, 'init_progress') && numel(cargs) == 3))
        error('Caller ID argument missing');
    elseif ~newIDNeeded && ~ismember(cargs{1}, s1.caller_id)
        error('Unknown caller ID');
    elseif ~newIDNeeded
        id = cargs{1};
    else
        if fieldCreationNeeded
            s.caller_id = [];
        endif
        id  = distinct_rand(s.caller_id);
        s.caller_id(end + 1) = id;
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return true if the caller is the "master caller".

function ret = is_master(s, id)

    ret = s.caller_id(1) == id;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Setup log file full name.

function s = setup_log_file_full_name(s1, cf)

    s = s1;
    if ~isfield(s1, 'logfile')
        if ~isempty(cf.logname)
            s.logfile = struct('fullname', ...
                absolute_path(fullfile(cf.logdir, cf.logname)));
        endif
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Setup the "need to warn that progress indication in the command window is
# automatically disabled" flag.

function s = setup_cmd_win_prog_warn_needed(s1, cf)

    s = s1;
    if ~isfield(s1, 'cmd_win_prog_auto_disa_warn_needed')
        s.cmd_win_prog_auto_disa_warn_needed ...
            = strcmp(cf.hmi_variant, 'command_window') && ~backspace_supported;
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Setup progress indicator format strings.

function s = setup_progress_formats(s1, cf)

    s = s1;
    if ~isfield(s1, 'progress_fmt')
        [~, fmt, order] = outman_is_valid_progress_format(cf.progress_format);
        [~, short_fmt, short_order] ...
            = outman_is_valid_progress_format(cf.progress_short_format);
        s.progress_fmt = struct('fmt', fmt, ...
            'order', order, ...
            'short_fmt', short_fmt, ...
            'short_order', short_order);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Setup progress indicator format strings.

function [s, id] = create_new_progress_if_max_count_not_reached(s1, cf, cargs)

    s = s1;
    if ~isfield(s1, 'progress')
        s = setup_progress_formats(s, cf);
        s.progress = struct();
        s.progress.id = [];
        s.progress.start = [];
        s.progress.finish = [];
        s.progress.percent = [];
        s.progress.message = {};
        s.progress.start_datenum = [];
        s.progress.last_update_datenum = now;
        s.progress.actually_shown = false(1, 0);
        s.progress.refresh_needed = false;

        s.progress.displayed_str = '';

        switch cf.hmi_variant

            case 'command_window'
                if s.cmd_win_prog_auto_disa_warn_needed
                    s = echo(s, cf, false, true, [cf.error_leader ...
                        'Won''t attempt to perform progress indication ' ...
                        'in this command window because backspace ' ...
                        '("fprintf(''\b'')") is not supported']);
                    s.cmd_win_prog_auto_disa_warn_needed = false;
                endif
                if backspace_supported
                    s.progress.more_was_on = more_is_on;
                    if s.progress.more_was_on
                        more('off');
                    endif
                endif

        endswitch
    endif

    if numel(s.progress.id) < cf.progress_max_count

        id = distinct_rand(s.progress.id);
        s.progress.id(end + 1) = id;
        offs = numel(cargs) - 3;
        s.progress.start(end + 1) = cargs{1 + offs};
        if cargs{2 + offs} <= cargs{1 + offs}
            s.progress.finish(end + 1) = ceil(cargs{1 + offs} + 1);
        else
            s.progress.finish(end + 1) = cargs{2 + offs};
        endif
        s.progress.percent(end + 1) = 0;
        s.progress.message{end + 1} = cargs{3 + offs};
        s.progress.start_datenum(end + 1) = now;
        s.progress.actually_shown(end + 1) = false;

    else
        id = -1;
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Update progress indicators.

function s = update_progress(s1, cf, cargs)

    s = s1;
    if isfield(s1, 'progress')
        [found, idx] = ismember(cargs{2}, s1.progress.id);
        if found

            if numel(cargs) == 3
                posArg = 3;
            else
                posArg = 5;
                s.progress.start(idx) = cargs{3};
                if cargs{4} <= cargs{3}
                    s.progress.finish(idx) = ceil(cargs{3} + 1);
                else
                    s.progress.finish(idx) = cargs{4};
                endif
            endif

            s = outman_update_progress_percent(s, idx, cargs{posArg});
            nowN = now;

            if s.progress.refresh_needed
                update_rate = outman_max_progress_indicator_rate;
            else
                update_rate = cf.progress_update_rate;
            endif
            if (nowN - s.progress.last_update_datenum) * 86400 ...
                    * update_rate >= 1

                switch cf.hmi_variant

                    case 'command_window'
                        s = outman_command_window_update_progress(s, cf, nowN);

                endswitch

                s.progress.last_update_datenum = nowN;
                s.progress.refresh_needed = false;
            endif
        endif
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shift progress indicator (no display update).

function s = shift_progress(s1, cargs)

    s = s1;
    if isfield(s1, 'progress')
        [found, idx] = ismember(cargs{2}, s1.progress.id);
        if found
            s.progress.percent(idx) ...
                = min([99, s.progress.percent(idx) + cargs{3} * 100]);
        endif
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Delete progress indicator.

function [s, duration] = delete_progress(s1, cf, idx)

    s = s1;
    s.progress.id(idx) = [];
    s.progress.start(idx) = [];
    s.progress.finish(idx) = [];
    s.progress.percent(idx) = [];
    s.progress.message(idx) = [];
    duration = now - s.progress.start_datenum(idx);
    s.progress.start_datenum(idx) = [];
    s.progress.actually_shown(idx) = [];
    if isempty(s.progress.id)

        switch cf.hmi_variant

            case 'command_window'
                if backspace_supported && ~more_is_on && s.progress.more_was_on
                    more('on');
                endif

        endswitch

        s = rmfield(s, 'progress');
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Terminate progress indicator.

function [s, duration] = terminate_progress(s1, cf, cargs)

    s = s1;
    duration = -1;
    if isfield(s1, 'progress')
        [found, idx] = ismember(cargs{2}, s1.progress.id);
        if found
            s.progress.last_update_datenum = 0;
            s = update_progress(s, cf, [cargs {s.progress.finish(idx)}]);

            switch cf.hmi_variant

                case 'command_window'
                    s = outman_command_window_erase_progress(s, idx);

            endswitch

            [s, duration] = delete_progress(s, cf, idx);
        endif
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cancel progress indicator.

function s = cancel_progress(s1, cf, cargs)

    s = s1;
    if isfield(s1, 'progress')
        [found, idx] = ismember(cargs{2}, s1.progress.id);
        if found

            switch cf.hmi_variant

                case 'command_window'
                    outman_command_window_erase_progress(s, idx);

            endswitch

            [s, ~] = delete_progress(s, cf, idx);

        endif
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cancel all progress indicators.

function s = cancel_all_progress(s1, cf)

    s = s1;
    if isfield(s1, 'progress')
        for k = 1 : numel(s1.progress.id)
            s = cancel_progress(s, cf, {s1.caller_id(1), s1.progress.id(k)});
        endfor
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Write string to log file.

function s = write_to_log_file(s1, cf, str)

    s = s1;
    if isfield(s1, 'logfile')
        # A log file is defined.

        if isfield(s1.logfile, 'id')
            # The log file is already opened or is not opened but is known to
            # not be writable (in this case, the file descriptor is -1).

            id = s1.logfile.id;
        else
            # The log file is not opened.

            try
                rotate_file(s.logfile.fullname, ...
                    cf.log_rotation_megabyte_threshold * 1000000);
            catch
                s = echo(s, cf, false, true, [cf.error_leader ...
                    'Unable to rotate log file ' s.logfile.fullname]);
            end_try_catch

            # Open the file for appending (text mode).
            id = fopen(s1.logfile.fullname, 'at');
            s.logfile.id = id;

            if id == -1
                # File opening failed.
                s = echo(s, cf, false, true, [cf.error_leader ...
                    'Unable to open file ' s.logfile.fullname]);
            endif
        endif

        if id ~= -1
            # Writing to the file may succeed.

            writeFailed = false;
            try
                fprintf(id, '%s\n', str);
            catch
                s = echo(s, cf, false, true, [cf.error_leader ...
                    'Unable to write to log file ' s.logfile.fullname]);
                writeFailed = true;
            end_try_catch
            if writeFailed
                s.logfile.id = -1;
                try
                    fclose(id);
                catch
                    1;
                end_try_catch
            else
                s.logfile.write_datenum = now;
            endif
        endif
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Close log file.

function s = close_log_file(s1)

    s = s1;
    if isfield(s1, 'logfile') && isfield(s1.logfile, 'id') ...
            && s1.logfile.id ~= -1
        try
            fclose(s1.logfile.id);
        catch
            1;
        end_try_catch
        s.logfile = rmfield(s.logfile, {'id', 'write_datenum'});
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Close log file if no writing to log file done for enough time.

function s = close_log_file_if_delay_expired(s1, cf)

    s = s1;
    if isfield(s1, 'logfile') ...
            && isfield(s1.logfile, 'write_datenum') ...
            && (now - s1.logfile.write_datenum) ...
                * 86400000 >= cf.log_close_ms_delay
        s = close_log_file(s);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Echo message to display and (depending on configuration) to log file.

function s = echo(s1, cf, also_to_file, word_wrap, x)

    s = s1;

    switch cf.hmi_variant

        case {'command_window', 'command_window_no_progress'}
            progress_displayed = strcmp(cf.hmi_variant, 'command_window') ...
                && backspace_supported ...
                && isfield(s, 'progress') ...
                && ~isempty(s.progress.displayed_str);
            if progress_displayed
                n = length(s.progress.displayed_str);
                # Backspace character ("\b") is used to erase.
                backspaceString = repmat('\b', [1, n]);
                if ~cf.progress_immediate_reshow
                    s.progress.displayed_str = '';
                    s.progress.refresh_needed = true;
                endif
                fprintf(backspaceString);
                fprintf(blanks(n));
                fprintf(backspaceString);
            endif

            w = command_window_width - 1;
            if word_wrap && w >= cf.min_width_for_word_wrapping && is_string(x)
                xx = wordwrap(x, w);
                cellfun(@disp, xx);
            else
                disp(x);
            endif

            if progress_displayed
                fprintf('%s', s.progress.displayed_str);
            endif

    endswitch

    if also_to_file && is_string(x)
        s = write_to_log_file(s, cf, x);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return second command argument if the first one is a numerical scalar (the
# caller ID), otherwise return first command argument.

function ret = first_non_id_arg_idx(cargs)

    if is_num_scalar(cargs{1})
        ret = 2;
    else
        ret = 1;
    endif

endfunction

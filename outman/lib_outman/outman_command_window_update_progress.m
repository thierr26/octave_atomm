## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## s} =} outman_command_window_update_progress (@var{s1}, @var{cf}, @var{nown})
##
## @code{outman_command_window_update_progress} is used by Outman.  It is a
## very specific function and may not be useful for any other application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = outman_command_window_update_progress(s1, cf, nown)

    s = s1;

    if backspace_supported

        # Build new displayed string for the progress indicators.
        str = outman_progress_string(s.progress.message, ...
            s.progress.percent, s.progress_fmt.fmt, s.progress_fmt.order, ...
            progress_duration_str(s, cf, nown));
        s.progress.actually_shown(:) = true;
        if length(str) >= command_window_width
            str = outman_progress_string(s.progress.message(1), ...
                s.progress.percent(1), s.progress_fmt.short_fmt, ...
                s.progress_fmt.short_order, '');
            s.progress.short = true;
            s.progress.actually_shown(2 : end) = false;
            if length(str) >= command_window_width
                str = '';
                s.progress.actually_shown(1) = false;
            endif
        else
            s.progress.short = false;
        endif

        if ~isempty(s.progress.displayed_str)
            # There was already a displayed string.

            strLen = length(str);
            n = length(s.progress.displayed_str);
            if n > strLen
                str = [str blanks(n - strLen)];
            endif
            strTrunc = str(1 : n);
            if ~strcmp(strTrunc, s.progress.displayed_str)
                # The displayed string must be partially erased and
                # re-displayed.

                lastIdent = find(strTrunc ~= s.progress.displayed_str, 1) - 1;

                # Backspace character ("\b") is used to erase.
                fprintf([repmat('\b', [1, n - lastIdent]) '%s'], ...
                    str(lastIdent + 1 : n));
            endif
            if strLen > n
                fprintf('%s', str(n + 1 : strLen));
            endif

        else

            # Nothing was displayed, display the new string.
            fprintf('%s', str);

        endif

        s.progress.displayed_str = str;
    endif

endfunction

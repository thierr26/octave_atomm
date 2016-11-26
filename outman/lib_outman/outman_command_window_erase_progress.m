## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## s} =} outman_command_window_erase_progress (@var{s1}, @var{idx})
##
## @code{outman_command_window_update_progress} is used by Outman.  It is a
## very specific function and may not be useful for any other application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = outman_command_window_erase_progress(s1, idx)

    s = s1;

    somethingToDo = backspace_supported ...
        && isfield(s1, 'progress') && ~isempty(s1.progress.displayed_str) ...
        && s1.progress.actually_shown(idx);
    if somethingToDo && numel(s1.progress.id) > 1
        # There are more than one progress indicators, only a part of the
        # displayed string must be erased.

        # Build the new displayed string for the remaining progress indicators.
        if s.progress.short
            st = 1;
            if idx == 1
                fi = length(s.progress.displayed_str);
            else
                fi = 0;
            endif
        else
            ord = s.progress_fmt.order;
            fmt = s.progress_fmt.fmt;
            fi = 0;
            for k = 1 : idx,
                st = fi + 1;
                fi = fi + outman_progress_indicator_length(...
                    s.progress.message{k}, fmt, ord);
            endfor
        endif
        keep = true(1, length(s.progress.displayed_str));
        keep(st : fi) = false;
        oldString = s.progress.displayed_str;
        s.progress.displayed_str ...
            = [s.progress.displayed_str(keep) blanks(fi - st + 1)];

        if ~strcmp(oldString, s.progress.displayed_str)
            lastIdent = find(oldString ~= s.progress.displayed_str, 1) - 1;

            # Backspace character ("\b") is used to erase.
            n = length(oldString);
            if isempty(lastIdent)
                backspaceString = '';
            else
                backspaceString = repmat('\b', [1, n - lastIdent]);
            endif
            fprintf([backspaceString '%s'], ...
                s.progress.displayed_str(lastIdent + 1 : n));
        endif

        s1.progress.actually_shown(idx) = false;

    elseif somethingToDo
        # There is only one progress indicator, the whole displayed string must
        # be erased.

        # Backspace character ("\b") is used to erase.
        fprintf(repmat('\b', [1, length(s.progress.displayed_str)]));
        fprintf(blanks(length(s.progress.displayed_str)));
        fprintf(repmat('\b', [1, length(s.progress.displayed_str)]));

        s.progress.displayed_str = '';
    endif

endfunction

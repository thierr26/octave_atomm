## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} duration_str (@var{dura_in_days})
## @deftypefnx {Function File} duration_str (@var{dura_in_days}, @var{s})
##
## Convert a duration in days into a human language string.
##
## The first argument (@var{dura_in_days}) is the duration in days.  Note that
## the absolute value of @var{dura_in_days} is used in the computations, so the
## returned string is identical for two opposite values of @var{dura_in_days}.
##
## The second (optional) argument is a structure containing the elementary
## strings used to build the returned string.  It must contain the following
## fields, which must all contain a non empty string:
##
## @table @asis
## @item days
## The word for "days", prepended with a space character and with the plural
## mark parenthesized.  Example: " day(s)".
##
## @item hours
## The word for "hours", prepended with a space character and with the plural
## mark parenthesized.  Example: " hour(s)".
##
## @item minutes
## The word for "minutes", prepended with a space character and with the plural
## mark parenthesized.  Example: " minute(s)".
##
## @item seconds
## The word for "seconds", prepended with a space character and with the plural
## mark parenthesized.  Example: " second(s)".
##
## @item separator
## A separator string.  Example: ", ".
##
## @item and
## The word for "and" with a space before and after.  Example: " and ".
##
## @item seconds_fmt
## Conversion specification (for use by the @code{sprintf} function) for the
## number of seconds in the returned string.  Example: "%.0f".
## @end table
##
## By default, the fields in the structure have the values given above as
## examples.
##
## @seealso{sprintf}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function str = duration_str(dura_in_days, varargin)

    s = validate_args(dura_in_days, varargin{:});
    d = abs(dura_in_days);

    shift = 1e-4;
    hours_per_day = 24;
    minutes_per_hour = 60;
    seconds_per_minute = 60;

    days = floor(d); % In days.
    d = max([0, (d - days) * hours_per_day]); % In hours.
    hours = floor(d + shift); % In hours.
    d =  max([0, (d - hours) * minutes_per_hour]); % In minutes.
    minutes = floor(d + shift); % In minutes.
    seconds = max([0, (d - minutes) * seconds_per_minute]); % In seconds.

    c = {};
    if days > shift
        c{end + 1} = sprintf('%d%s', days, singular_or_plural(s.days, days));
    endif
    if hours > shift
        c{end + 1} = sprintf('%d%s', hours, ...
            singular_or_plural(s.hours, hours));
    endif
    if minutes > shift
        c{end + 1} ...
            = sprintf('%d%s', minutes, singular_or_plural(s.minutes, minutes));
    endif
    if seconds > shift
        c{end + 1} = sprintf([s.seconds_fmt '%s'], ...
                seconds, singular_or_plural(s.seconds, seconds));
    endif

    if ~isempty(c)
        n = numel(c);
        nn = cell_cum_numel(c) ...
            + max([0, n - 2]) * length(s.separator) ...
            + double(n > 1) * length(s.and);
        str = blanks(nn);
        level = 0;
        ls = length(s.separator);
        for k = 1 : n

            level1 = level;
            level = level1 + length(c{k});
            str(level1 + 1 : level) = c{k};

            if k <= n - 2
                level1 = level;
                level = level1 + ls;
                str(level1 + 1 : level) = s.separator;
            elseif k == n - 1
                level1 = level;
                level = level1 + length(s.and);
                str(level1 + 1 : level) = s.and;
            endif
        endfor
    else
        str = ['0' singular_or_plural(s.seconds, 0)];
    endif

endfunction

# -----------------------------------------------------------------------------

# Validate main function's arguments.

function s = validate_args(dura_in_days, varargin)

    validated_mandatory_args({@is_num_scalar}, dura_in_days);
    s = validated_opt_args(...
        {@is_valid_fmt_s, struct(...
            'days', ' day(s)', ...
            'hours', ' hour(s)', ...
            'minutes', ' minute(s)', ...
            'seconds', ' second(s)', ...
            'separator', ', ', ...
            'and', ' and ', ...
            'seconds_fmt', '%.0f' ...
        )}, varargin{:});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return true for a valid format structure.

function ret = is_valid_fmt_s(s)

    ret = isstruct(s) && isfield(s, 'days') && isfield(s, 'hours') ...
        && isfield(s, 'minutes') && isfield(s, 'seconds') ...
        && isfield(s, 'separator') && isfield(s, 'and') ...
        && is_non_empty_string('days') && is_non_empty_string('hours') ...
        && is_non_empty_string('minutes') && is_non_empty_string('seconds') ...
        && is_non_empty_string('separator') && is_non_empty_string('and');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Examples for function singular_or_plural:
#
#     * singular_or_plural('minute', 1) returns "minute".
#
#     * singular_or_plural('minute', 2) returns "minute".
#
#     * singular_or_plural('minute(s)', 1) returns "minute".
#
#     * singular_or_plural('minute(s)', 2) returns "minutes".

function ret = singular_or_plural(str, n)

    openingP = strfind(str, '(');
    closingP = strfind(str, ')');
    if ~isempty(openingP) && ~isempty(closingP)
        openingP = openingP(1);
        closingP = closingP(1);
        keep = true(1, length(str));
        if n < 2
            keep(openingP : closingP) = false;
        else
            keep(openingP) = false;
            keep(closingP) = false;
        endif
        ret = str(keep);
    else
        ret = str;
    endif

endfunction

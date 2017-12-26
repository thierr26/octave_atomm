## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{a} =} weeknum_range (@var{year})
## @deftypefnx {Function File} {@var{a} =} weeknum_range (@var{year}, @var{@
## month})
## @deftypefnx {Function File} {@var{a} =} weeknum_range ([@var{year} @var{@
## month}])
##
## Week number range for a year or month.
##
## @code{@var{a} = weeknum_range (@var{year})} returns in vector @var{a} the
## week the valid week numbers for year @var{year}.  It can be @code{1 : 52} or
## @code{1 : 53}.  From Wikipedia
## (@uref{https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year}): Years
## with 53 weeks in them can be described by any of the following equivalent
## definitions:
##
## @itemize @bullet
## @item Any year starting on Thursday and any leap year starting on Wednesday.
##
## @item Any year ending on Thursday and any leap year ending on Friday.
##
## @item Years in which January 1st and December 31st (in common years) or
## either (in leap years) are Thursdays.
## @end itemize
##
## Examples:
##
## @example
## @group
## weeknum_range (1992)
##    @result{} 1 : 53
## @end group
## @end example
##
## @example
## @group
## weeknum_range (2013)
##    @result{} 1 : 52
## @end group
## @end example
##
## @example
## @group
## weeknum_range (2017)
##    @result{} 1 : 52
## @end group
## @end example
##
## @example
## @group
## weeknum_range (2026)
##    @result{} 1 : 53
## @end group
## @end example
##
## If a month number is provided, then the numbers of the weeks which have no
## days in this month are removed from the output.
##
## @example
## @group
## weeknum_range (2017, 11)
##    @result{} 44 : 48
## @end group
## @end example
##
## @example
## @group
## weeknum_range ([2017, 11])
##    @result{} 44 : 48
## @end group
## @end example
##
## @example
## @group
## weeknum_range (2017, 1)
##    @result{} 1 : 5
## @end group
## @end example
##
## @example
## @group
## weeknum_range (2014, 12)
##    @result{} 49 : 52
## @end group
## @end example
##
## @seealso{weekday}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function a = weeknum_range(v, varargin)

    validated_mandatory_args({@(x) is_integer_vect(x) && numel(x) <= 2}, v);
    monthProvided = true;
    month = 1;
    if numel(v) == 2
        assert(nargin == 1, ['There should be no second argument because ' ...
            'the month number is already provided in first argument']);
        month = v(2);
    elseif nargin == 2
        month = validated_opt_args({@is_integer_scalar, 1}, varargin{:});
    else
        monthProvided = false;
    endif
    assert(~monthProvided || (month >= 1 && month <= 12), ['%d is not a ' ...
        'valid month number (valid month numbers are integers from 1 to ' ...
        '12)'], month);

    year = v(1);

    [n0, d0] = month_first_day(year, 1);
    isLeap = is_leap_yr(year);
    if d0 == 4 || (isLeap && d0 == 3)
        a = 1 : 53;
    else
        a = 1 : 52;
    endif

    if monthProvided

        if month > 1
            [n1, d1] = month_first_day(year, month);
            [n, wN] = first_week_day(n0, d0, d1);
            wN1 = wN + (n1 - n) / 7;
            a = a(a >= wN1);
        endif

        if month < 12
            [n2, d2] = month_last_day(year, month, isLeap);
            [n, wN] = first_week_day(n0, d0, d2);
            wN2 = wN + (n2 - n) / 7;
            a = a(a <= wN2);
        endif

    endif

endfunction

% -----------------------------------------------------------------------------

% Monday based week day (monday is 1, sunday is 7).

function ret = monday_based_weekday(x)

    ret = weekday(x) - 1;
    if ret == 0
        ret = 7;
    endif

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Number of days in a month.

function ret = month_day_count(month, is_leap_y)

    persistent a;

    if isempty(a)
        a = [31 28 31 30 31 30 31 31 30 31 30 31];
    endif

    ret = a(month);
    if is_leap_y && month == 2
        ret = ret + 1;
    endif

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Serial day number and week day (monday based) of the first day of a month.

function [n, d] = month_first_day(year, month)

    n = datenum([year month 1]);
    d = monday_based_weekday(n);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Serial day number and week day (monday based) of the last day of a month.

function [n, d] = month_last_day(year, month, is_leap_y)

    n = datenum([year month month_day_count(month, is_leap_y)]);
    d = monday_based_weekday(n);

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Serial day number and week day (monday based) of the next day.

function [n, d] = next_day(n1, d1)

    n = n1 + 1;
    if d1 == 7
        d = 1;
    else
        d = d1 + 1;
    endif

endfunction

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Serial day number and week number (which can be 0 or 1) of the first day of
% the year being a particular day d (1 for monday, 7 for sunday).

function [n, w_n] = first_week_day(n0, d0, d)

    if d0 <= 4
        w_n = 1;
    else
        w_n = 0;
    endif
    n = n0;
    dVar = d0;
    while dVar ~= d
        [n, dVar] = next_day(n, dVar);
        if dVar == 1
            w_n = w_n + 1;
        endif
    endwhile

endfunction

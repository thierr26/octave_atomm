## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_leap_yr ()
## @deftypefnx {Function File} {@var{ret} =} is_leap_yr (@var{years})
##
## True for leap years.
##
## @code{@var{ret} = is_leap_yr (@var{years})} returns a logical array with the
## same shape as numerical array @var{years}.  @var{ret} contains true values
## for leap years and false values for common years.
##
## If argument @var{years} is not provided, then @code{is_leap_yr} returns true
## if the current year is a leap year, false otherwise.
##
## When used in Octave, this function actually calls Octave function
## @code{is_leap_year}.  When used in another interpreter, the function uses
## its internal implementation of the leap year determination algorithm.
##
## From Wikipedia (@uref{https://en.wikipedia.org/wiki/Leap_year#Algorithm}):
##
## @verbatim
## if (year is not divisible by 4) then (it is a common year)
## else if (year is not divisible by 100) then (it is a leap year)
## else if (year is not divisible by 400) then (it is a common year)
## else (it is a leap year)
## @end verbatim
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_leap_yr(years)

    assert(nargin <= 1, 'Too many arguments');
    if nargin == 1
        year = years;
    else
        v = clock;
        year = v(1);
    endif

    if is_octave
        ret = is_leap_year(year);
    else
        ret = (rem (year, 4) == 0 & rem (year, 100) ~= 0) ...
            | rem (year, 400) == 0;
    endif

endfunction

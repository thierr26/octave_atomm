## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_progress_indicator_length (@var{@
## msg}, @var{fmt}, @var{ord})
##
## Length of displayed string for a progress indicator, used by @code{outman}.
##
## @code{outman_progress_indicator_length} returns a string length.  The
## arguments are:
##
## @table @asis
## @item @var{msg}
## A string.
##
## @item @var{fmt}
## A template string that can be used as argument to @code{fprintf} and
## @code{sprintf}, supposed to be an output of
## @code{outman_is_valid_progress_format} (second output argument).
##
## @item @var{ord}
## A parameter order vector, supposed to have been output by
## @code{outman_is_valid_progress_format} (third argument) along with
## @var{fmt}.
## @end table
##
## No check is done on the arguments.
##
## The returned length is the length of the string that would returned by
## @code{sprintf} when called with @var{fmt} as template string, @var{msg} as
## substitution string for the "%s" conversion specification (if any) and any
## integer from 0 to 100 as substitution value for the "%3d" conversion
## specification (if any).
##
## @seealso{fprintf, outman, outman_is_valid_progress_format, sprintf}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_progress_indicator_length(msg, fmt, ord)

    s1 = '%s';
    s1Len = length(s1);
    s2 = '%3d';
    if ismember(1, ord)
        d1 = length(msg) - s1Len;
    else
        d1 = 0;
    endif
    if ismember(2, ord)
        d2 = length(sprintf(s2, 0)) - length(s2);
    else
        d2 = 0;
    endif
    c = {blanks(s1Len), 0};
    ret = length(sprintf(fmt, c{ord})) + d1 + d2;

endfunction

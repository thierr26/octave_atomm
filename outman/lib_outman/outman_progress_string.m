## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{str} =} outman_progress_string (@var{@
## msg}, @var{pc}, @var{fmt}, @var{ord}, @var{dura_str})
##
## String to be displayed by Outman for progress indication.
##
## @code{@var{str} = outman_progress_string (@var{msg}, @var{pc}, @var{@
## fmt}, @var{ord}, @var{dura_str})} builds a string (@var{str}) that Outman
## displays for progress indication.  The arguments are:
##
## @table @asis
## @item @var{msg}
## A row cell array of strings.
##
## @item @var{pc}
## Numerical array (with the same shape as @var{msg}) of numbers from 0 to 100.
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
##
## @item @var{dura_str}
## A string representation of the task duration to be displayed.  This could be
## an output of @code{duration_str} or an empty string.
## @end table
##
## No argument checking is done.
##
## @seealso{datenum, duration_str, fprintf, now, outman,
## outman_is_valid_progress_format}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function str = outman_progress_string(msg, pc, fmt, ord, dura_str)

    count = numel(msg);
    n = 0;
    for k = 1 : count
        n = n + outman_progress_indicator_length(msg{k}, fmt, ord);
    endfor
    str = blanks(n);
    level = 0;
    for k = 1 : count
        level1 = level;
        c = {msg{k}, floor(pc(k))};
        st = sprintf(fmt, c{ord});
        level = level1 + length(st);
        str(level1 + 1 : level) = st;
    endfor
    if ~isempty(dura_str)
        level1 = level;
        level = level1 + length(dura_str) + 1;
        str(level1 + 1 : level) = [' ' dura_str];
    endif

endfunction

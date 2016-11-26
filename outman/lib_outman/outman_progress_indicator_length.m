## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## len} =} outman_progress_indicator_length (@var{msg}, @var{fmt}, @var{ord})
##
## Length of displayed string for an Outman progress indicator.
##
## The first argument (@var{msg}) is supposed to be a simple string.
##
## The second and third arguments (@var{fmt} and @var{ord}) are supposed to
## have been returned by function @code{outman_is_valid_progress_format} in
## its second and third output arguments respectively.
##
## No argument checking is done.
##
## @code{@var{len} = outman_progress_indicator_length (@var{msg}, @var{@
## fmt}, @var{ord})} returns in @var{len} the length of a string.  This string
## is @var{fmt} with the "%s" conversion specification (if present) substituted
## with @var{msg} and the "%3d" conversion specification (if present)
## substituted with a 3 digit integer.
##
## @seealso{outman, outman_is_valid_progress_format}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function len = outman_progress_indicator_length(msg, fmt, ord)

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
    len = length(sprintf(fmt, c{ord})) + d1 + d2;

endfunction

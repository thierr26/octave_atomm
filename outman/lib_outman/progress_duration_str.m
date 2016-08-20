## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} progress_duration_str (@var{s}, @var{cf}, @var{@
## nown})
##
## Duration (as a string) to be displayed along with an Outman progress
## indicator.
##
## @var{s} is the Outman application state structure and is expected to have
## a "progress" field containing a start_datenum field (non empty numerical
## array).
##
## @var{cf} is the Outman configuration structure and is expected to have a
## "progress_display_duration" field (logical scalar).
##
## @var{nown} is the current date as returned by function @code{now}.
##
## @seealso{now, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = progress_duration_str(s, cf, nown)

    if cf.progress_display_duration
        ret = duration_str(nown - s.progress.start_datenum(1));
    else
        ret = '';
    endif

endfunction

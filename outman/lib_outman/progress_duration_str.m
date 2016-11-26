## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{str} =} progress_duration_str (@var{@
## s}, @var{cf}, @var{nown})
##
## Duration (string) to be displayed along with an Outman progress indicator.
##
## @code{progress_duration_str} is used by Outman.  It is a very specific
## function and may not be useful for any other application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function str = progress_duration_str(s, cf, nown)

    if cf.progress_display_duration
        str = duration_str(nown - s.progress.start_datenum(1));
    else
        str = '';
    endif

endfunction

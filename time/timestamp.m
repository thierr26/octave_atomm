## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} timestamp ()
##
## Timestamp string.
##
## @code{timestamp} returns the current date as a string.  The format is like
## "2016-03-14T19:20:21".
##
## @seealso{datestr, now}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function str = timestamp

    str = datestr(now, 'yyyy-mm-ddTHH:MM:SS');

endfunction

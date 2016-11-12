## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is ()
##
## Return true.
##
## @code{is} takes no argument and always returns true.  It can be useful as an
## argument validation function for application@footnote{Please see the
## documentation for function @code{mentalsum} for details about what is an
## application in this context.} commands that take no argument.
##
## @seealso{mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is

    ret = true;

endfunction

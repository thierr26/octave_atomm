## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_kill ()
##
## Force Outman's shutdown.
##
## @code{outman_kill} is useful when for whatever reason Outman's master caller
## has not disconnected and the master caller ID is lost.
##
## A @code{outman_kill ()} statement shuts down outman.
##
## Of course, the preferred way to shut down Outman is to issue a
## @code{outman('disconnect', @var{master_caller_id})} statement.
##
## Outman usage is fully documented in the help for Outman. Please issue a
## @code{help outman} command to read it.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function outman_kill

    munlock('outman');
    clear('outman');

endfunction

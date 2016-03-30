## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_kill ()
##
## Unlock and clear Outman's main function.
##
## @code{outman_kill} is usefull when, for whatever reason, Outman has not been
## exited properly and you need to make it ready for a new start with possibly
## new configuration parameters.
##
## Of course, the preferred way when applicable to unlock and clear Outman's
## main function is to exit it with the dedicated command:
## @code{outman('disconnect', @var{master_caller_id})}.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function outman_kill

    munlock('outman');
    clear('outman');

endfunction

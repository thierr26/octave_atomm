## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} outman_alias_stru ()
##
## Outman's alias structure.
##
## @code{@var{s} = outman_alias_stru ()} returns the alias structure of Outman
## in @var{s}.
##
## Please issue a @code{help mentalsum} statement for details about the alias
## structure of applications like Outman.
##
## @seealso{mentalsum, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = outman_alias_stru

    s = struct(...
        'q', {{'quit'}}, ...
        'exit', {{'quit'}}, ...
        'bye', {{'quit'}}, ...
        'clear', {{'quit'}}, ...
        'disconnect', {{'quit'}});

endfunction

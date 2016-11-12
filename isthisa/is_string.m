## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_string (@var{str})
##
## True for a simple string.
##
## @code{@var{ret} = is_string (@var{str})} returns true in @var{ret} if @var{@
## str} is a simple string (i.e.@ a row vector of characters or an empty
## character array).
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_string(str)

    ret = ischar(str) && (isrow(str) || isempty(str));

endfunction

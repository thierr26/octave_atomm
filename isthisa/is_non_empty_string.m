## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_non_empty_string (@var{str})
##
## True for a non empty string.
##
## @code{@var{ret} = is_non_empty_string (@var{str})} returns true in @var{ret}
## if @var{str} is a non empty string (a row vector of characters).
##
## @seealso{is_blank_string, is_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_non_empty_string(str)

    ret = ischar(str) && isrow(str);

endfunction

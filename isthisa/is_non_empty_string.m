## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_non_empty_string (@var{str})
##
## Return true if @var{str} is a non empty string (a row vector of characters).
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_non_empty_string(str)

    ret = ischar(str) && isrow(str);

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} same_shape (@var{array1}, @var{@
## array2})
##
## True if @var{array1} and @var{array2} have the same shape.
##
## @code{@var{ret} = same_shape (@var{array1}, @var{array2})} returns in
## @var{ret} the value of
## @code{isequal(size(@var{array1}), size(@var{array2}))}.
##
## @seealso{isequal, size}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = same_shape(array1, array2)

    ret = isequal(size(array1), size(array2));

endfunction

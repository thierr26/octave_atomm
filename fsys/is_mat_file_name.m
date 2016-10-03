## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{flag} =} is_mat_file_name (@var{str})
##
## Return true for a string ending with ".mat".
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_mat_file_name(str)

    ret = is_matched_by(str, '\.mat$');

endfunction

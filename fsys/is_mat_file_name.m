## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_mat_file_name (@var{str})
##
## True for a string ending with ".mat".
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_mat_file_name(str)

    ret = is_matched_by(str, '\.mat');

endfunction

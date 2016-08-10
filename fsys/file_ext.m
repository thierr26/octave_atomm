## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} file_ext (@var{filename})
##
## Extension of file @var{filename}, including the dot.
##
## If @var{filename} is an empty string or has no extension, then an empty
## string is returned.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ext = file_ext(filename)

    [~, ~, ext] = fileparts(filename);

endfunction

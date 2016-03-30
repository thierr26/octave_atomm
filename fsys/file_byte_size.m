## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} file_byte_size (@var{filename})
##
## Byte size of file @var{filename}.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function n = file_byte_size(filename)

    validated_mandatory_args({@is_non_empty_string}, filename);

    if exist(filename, 'file')
        s = dir(filename);
        n = s.bytes;
    else
        error('File %s does not exist', filename);
    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_blank_string (@var{str})
##
## True for an empty string or a string containing only blank characters (for
## example spaces and tabulations).
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_blank_string(str)

    validated_mandatory_args({@is_string}, str);
    ret = isempty(str) || is_matched_by(str, '^\s*$');

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_matched_by (@var{str}, @var{expr})
##
## Return true if the string @var{str} is matched by the regular expression
## @var{expr}.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_matched_by(str, expr)

    validated_mandatory_args({@is_string, @is_non_empty_string}, str, expr);
    ret = ~isempty(regexp(str, expr, 'once'));

endfunction

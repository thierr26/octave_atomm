## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_matched_by (@var{str}, @var{expr})
##
## Return true if the string @var{str} is matched by the regular expression
## @var{expr}.
##
## @var{str} can be a cell array of strings. In this case, @code{is_matched_by}
## returns a logical array (same shape as @var{str}).
##
## @seealso{is_string, iscellstr}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_matched_by(str, expr)

    validated_mandatory_args(...
        {@(x) is_string(x) || iscellstr(x), @is_non_empty_string}, str, expr);

    if iscell(str)
        ret = cellfun(@(x) ~isempty(x), regexp(str, expr, 'once'));
    else
        ret = ~isempty(regexp(str, expr, 'once'));
    endif

endfunction

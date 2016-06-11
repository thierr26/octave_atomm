## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_prefixed_with (@var{str}, @var{prefix})
##
## Return true if the string @var{str} starts with string @var{prefix}.
##
## @var{str} can be a cell array of strings. In this case,
## @code{is_prefixed_with} returns a logical array (same shape as @var{str}).
##
## @seealso{is_matched_by}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_prefixed_with(str, prefix)

    validated_mandatory_args(...
        {@(x) is_string(x) || is_cell_array_of_strings(x), ...
            @is_non_empty_string}, str, prefix);

    if iscell(str)
        ret = cellfun(@(x) strncmp(x, prefix, numel(prefix)), str);
    else
        ret = strncmp(str, prefix, numel(prefix));
    endif

endfunction

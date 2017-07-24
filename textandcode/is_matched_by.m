## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_matched_by (@var{str}, @var{@
## expr})
## @deftypefnx {Function File} {@var{ret} =} is_matched_by (@var{str}, @var{@
## expr}, @var{case_sensitive})
##
## True for a string that matches a regular expression.
##
## @code{@var{ret} = is_matched_by (@var{str}, @var{expr})} returns true in
## @var{ret} if the string @var{str} is matched case sensitive by the regular
## expression @var{expr}.
##
## @code{@var{ret} = is_matched_by (@var{str}, @var{expr}, true)} is equivalent
## to @code{@var{ret} = is_matched_by (@var{str}, @var{expr})}.
##
## @code{@var{ret} = is_matched_by (@var{str}, @var{expr}, false)} performs a
## case insensitive match.
##
## @var{str} can be a cell array of strings.  In this case, @var{ret} is a
## logical array (same shape as @var{str}).
##
## @seealso{is_string, is_cell_array_of_strings, is_prefixed_with}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_matched_by(str, expr, varargin)

    validated_mandatory_args(...
        {@(x) is_string(x) || is_cell_array_of_strings(x), ...
            @is_non_empty_string}, str, expr);

    opt = {'once', 'ignorecase'};
    if validated_opt_args({@is_logical_scalar, true}, varargin{:})
        opt = opt(1 : end - 1);
    endif

    if iscell(str)
        ret = cellfun(@(x) ~isempty(x), regexp(str, expr, opt{:}));
    else
        ret = ~isempty(regexp(str, expr, opt{:}));
    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} string_or_cellstr_arg_or_none_opt_logical (...)
##
## True if none or one (simple or array of) non empty string argument provided.
## A trailing logical scalar argument is tolerated.
##
## @seealso{is_non_empty_string, is_cell_array_of_non_empty_strings,
## string_or_cellstr_arg_or_none}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = string_or_cellstr_arg_or_none_opt_logical(varargin)

    if nargin > 0 && is_logical_scalar (varargin{end})
        ret = string_or_cellstr_arg_or_none(varargin{1 : end - 1});
    else
        ret = string_or_cellstr_arg_or_none(varargin{:});
    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} string_or_cellstr_arg_or_none (...)
##
## True if none or one (simple or array of) non empty string argument provided.
##
## @seealso{is_non_empty_string, is_cell_array_of_non_empty_strings,
## string_or_cellstr_arg_or_none_opt_logical}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = string_or_cellstr_arg_or_none(varargin)

    ret = nargin == 0 ...
        || (nargin == 1 && (is_non_empty_string(varargin{1}) ...
            || is_cell_array_of_non_empty_strings(varargin{1})));

endfunction

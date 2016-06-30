## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_cell_array_of_func_handle (@var{c})
##
## Return true if @var{c} is a cell array of function handles or an empty cell
## array.
##
## Examples:
##
## @example
## @group
## is_cell_array_of_func_handle (@{@@iscell@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## is_cell_array_of_func_handle (@{@@iscell, @@isstruct@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## is_cell_array_of_func_handle (@{@@iscell; @@isstruct@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## c = @{@@iscell, @@isstruct; @@isstruct, @@iscell@});
## is_cell_array_of_func_handle (c)
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## is_cell_array_of_func_handle (@{@})
##    @result{} true
## @end group
## @end example
##
## @example
## @group
## is_cell_array_of_func_handle (@@iscell)
##    @result{} false
## @end group
## @end example
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_cell_array_of_func_handle(c)

    if nargin ~= 1
        error('One and only one argument expected');
    endif

    try
        ret = all(cellfun(@(x) isa(x, 'function_handle'), c(:)));
    catch
        ret = false;
    end_try_catch

endfunction

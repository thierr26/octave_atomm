## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{c} =} struct2namevaluepairs (@var{s})
##
## Convert a structure to a "name-value pairs" cell array.
##
## @code{@var{c} = struct2namevaluepairs (@var{s})} returns a row cell array
## with the names of the fields of structure @var{s} in the components with an
## odd index and the field values in the components with an even index.
##
## @var{s} must be scalar or empty structures.  In the case where @var{s} is
## empty, then the returned cell array is empty.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function c = struct2namevaluepairs(s)

    validated_mandatory_args({@isstruct}, s);

    if isempty(s) || isempty(fieldnames(s))
        c = {};
    else
        validated_mandatory_args({@is_non_empty_scalar_structure}, s);

        [fn, n] = field_names_and_count(s);
        c = cell(1, 2 * n);
        for k = 1 : n
            c{2 * k - 1} = fn{k};
            c{2 * k} = s.(fn{k});
        endfor
    endif

endfunction

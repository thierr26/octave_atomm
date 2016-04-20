## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} merge_struct (@var{s1}, @var{s2})
##
## Merge two structures into one.
##
## @code{merge_struct} returns a structure having the fields of both @var{s1}
## and @var{s2}.  If one or more fields exist in both structures, then
## @code{merge_struct} issues an error.
##
## @var{s1} and @var{s2} must be scalar or empty structures.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = merge_struct(s1, s2)

    validated_mandatory_args({@isstruct, @isstruct}, s1, s2);

    if isempty(s1)
        s1V = s2;
        s2V = s1;
    else
        s1V = s1;
        s2V = s2;
    endif

    s = s1V;

    for c = fieldnames(s2V)'
        fieldName = c{1};
        if isfield(s1V, fieldName)
            error('field %s exist in both structures', fieldName);
        else
            s.(fieldName) = s2V.(fieldName);
        endif
    endfor

endfunction

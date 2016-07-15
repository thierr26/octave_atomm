## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} clean_up_struct (@var{s}, @var{c})
##
## Remove fields from first structure argument that are not in second argument.
##
## @code{clean_up_struct(@var{s}, @var{c})} returns a structure that is
## identical to @var{s} except that fields that are not in the field names list
## @var{c} are removed.  @var{c} must be a cell array of strings, and can be
## empty.
##
## @seealso{is_cell_array_of_strings, fieldnames, rmfield}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = clean_up_struct(s, c)

    validated_mandatory_args(...
        {@isstruct, @is_cell_array_of_strings}, s, c);

    ret = s;
    [f, n] = field_names_and_count(s);
    for k = 1 : n
        if ~ismember(f{k}, c)
            ret = rmfield(ret, f{k});
        endif
    endfor

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} clean_up_struct (@var{s1}, @var{c})
##
## Remove structure fields that are not in a given field list.
##
## @code{@var{s} = clean_up_struct(@var{s1}, @var{c})} returns in @var{s} a
## structure that is identical to @var{s1} except that the fields that are not
## in the field names list @var{c} are removed.  @var{c} must be a cell array
## of strings and can be empty.
##
## @seealso{is_cell_array_of_strings, fieldnames, rmfield}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = clean_up_struct(s1, c)

    validated_mandatory_args(...
        {@isstruct, @is_cell_array_of_strings}, s1, c);

    s = s1;
    [f, n] = field_names_and_count(s1);
    for k = 1 : n
        if ~ismember(f{k}, c)
            s = rmfield(s, f{k});
        endif
    endfor

endfunction

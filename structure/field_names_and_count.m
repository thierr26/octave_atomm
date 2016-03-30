## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{c}, @var{n}] =} field_names_and_count (@var{s})
##
## Return the list of the field names as well the number of fields for a
## structure.
##
## @var{c} is a cell array of strings containing the field names for structure
## @var{s}, as returned by @code{fieldnames}.
##
## @var{n} is the number of elements in @var{c}, as returned by @code{numel}.
##
## @seealso{fieldnames, numel}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [c, n] = field_names_and_count(s)

    validated_mandatory_args({@isstruct}, s);

    c = fieldnames(s);
    n = numel(c);

endfunction

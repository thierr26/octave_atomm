## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{c}, @var{n}] =} field_names_and_count (@var{s})
##
## Field names list and number of fields for a structure.
##
## @code{[@var{c}, @var{n}] = field_names_and_count (@var{s})} returns
## @code{fieldnames (@var{s})} in @var{c} and @code{numel (@var{c})} in
## @var{n}.
##
## @var{s} must be a structure.
##
## @seealso{fieldnames, numel}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [c, n] = field_names_and_count(s)

    validated_mandatory_args({@isstruct}, s);

    c = fieldnames(s);
    n = numel(c);

endfunction

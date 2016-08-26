## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_identifier (@var{str})
##
## True for a string that is a valid variable name or structure field name.
##
## @code{is_identifier (@var{str})} returns true if @var{str} is a valid
## identifier, i.e.@ a string that can be used as a variable name or as a
## structure field name.
##
## Valid identifiers are strings for which function @code{isvarname} returns
## true and that are at most @code{namelengthmax} characters long.
##
## @seealso{isvarname, namelengthmax}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_identifier(str)

    validated_mandatory_args({@is_string}, str);

    ret = isvarname(str) && length(str) <= namelengthmax;

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{filename} =} timestamp2filename (@var{str})
##
## Transform a timestamp string for use as filename or filename part.
##
## Precisely, @code{@var{filename} = timestamp2filename (@var{str}} returns in
## @var{filename} string @var{str} with occurrences of "T" substituted with an
## underscore ("_") and occurrences of colons (":") substituted with dashes
## ("-").
##
## @var{str} can be a string (and in this case the return value is a string)
## or a cell array of strings (and in this case the return value is a cell
## array of string).
##
## Example:
##
## @example
## @group
## timestamp2filename ("2012-12-12T12:12:12")
##    @result{} "2012-12-12_12-12-12"
## @end group
## @end example
##
## @seealso{is_string, is_cell_array_of_non_empty_strings, timestamp}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function filename = timestamp2filename(str)

    validated_mandatory_args(...
        {@(x) is_string(x) || is_cell_array_of_non_empty_strings(x)}, str);
    filename = strrep(strrep(str, 'T', '_'), ':', '-');

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} timestamp2filename (@var{str})
##
## Transform a timestamp string for use as filename or filename part.
##
## Precisely, @code{timestamp2filename} substitutes "T" with an underscore
## ("_") and substitutes the colons (":") with dashes ("-").
##
## @var{str} can be a string (and in this case the return value is a string)
## or a cell array of strings.
##
## @seealso{is_string, is_cell_array_of_non_empty_strings, timestamp}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = timestamp2filename(str)

    validated_mandatory_args(...
        {@(x) is_string(x) || is_cell_array_of_non_empty_strings(x)}, str);
    ret = strrep(strrep(str, 'T', '_'), ':', '-');

endfunction

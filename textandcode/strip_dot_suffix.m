## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} strip_dot_suffix (@var{c})
##
## Remove the dot suffix in a cell array of strings.
##
## @code{strip_dot_suffix(@var{c})} returns a cell array of strings similar
## to @var{c} except that the dot suffixes are removed.
##
## Example:
##
## @example
## @group
## strip_dot_suffix (@{'www.gnu.org', 'www.linux.com'@})
##    @result{} @{'www.gnu', 'www.linux'@}
## @end group
## @end example
##
## @code{strip_dot_suffix} also accepts a string as argument.  In this case,
## the return value is a string.
##
## @seealso{is_cell_array_of_strings, is_string}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = strip_dot_suffix(c)

    validated_mandatory_args(...
        {@(x) (iscell(x) && is_cell_array_of_strings(x)) || is_string(x)}, c);

    ce = c;
    if ~iscell(c)
        ce = {c};
    endif

    ret = cellfun(@strip, ce, 'UniformOutput', false);

    if ~iscell(c)
        ret = ret{1};
    endif

endfunction

# -----------------------------------------------------------------------------

# Strip the dot suffix (if any) from a string.

function ret = strip(str)

    pos = strfind(str, '.');
    if isempty(pos)
        ret = str;
    else
        ret = str(1 : pos(end) - 1);
    endif

endfunction

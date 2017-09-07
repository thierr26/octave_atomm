## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} list_string (@var{c})
## @deftypefnx {Function File} {@var{ret} =} list_string (@var{c}, @var{sep})
## @deftypefnx {Function File} {@var{ret} =} list_string (@var{c}, @var{@
## sep}, @var{opening})
## @deftypefnx {Function File} {@var{ret} =} list_string (@var{c}, @var{@
## sep}, @var{opening}, @var{closing})
## @deftypefnx {Function File} {@var{ret} =} list_string (@var{c}, @var{@
## sep}, @var{opening}, @var{closing}, @var{gopening})
## @deftypefnx {Function File} {@var{ret} =} list_string (@var{c}, @var{@
## sep}, @var{opening}, @var{closing}, @var{gopening}, @var{gclosing})
##
## Convert cell array of strings to string.
##
## @code{@var{ret} = list_string (@var{c}} concatenates the elements in @var{c}
## (separated with comas + white space sequences) and returns the resulting
## string in @var{ret}.
##
## @example
## @group
## list_string (@{'abc', 'defg'@})
##    @result{} 'abc, defg'
## @end group
## @end example
##
## Up to 5 optional arguments can be provided:
##
## @enumerate
## @item @var{sep}
##
## Element separator. Defaults to @qcode{", "}.
##
## @item @var{opening}
##
## Element opening sequence. Defaults to an empty string.
##
## @item @var{closing}
##
## Element closing sequence. Defaults to an empty string.
##
## @item @var{gopening}
##
## Global string opening sequence. Defaults to an empty string.
##
## @item @var{gclosing}
##
## Global string closing sequence. Defaults to an empty string.
## @end enumerate
##
## @example
## @group
## list_string (@{'abc', 'defg'@}, '; ', '''', '''', '@{', '@}')
##    @result{} '@{'abc'; 'defg'@}'
## @end group
## @end example
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = list_string(c, varargin)

    validated_mandatory_args({@is_cell_array_of_strings}, c);
    [sep, opening, closing, gopening, gclosing] = validated_opt_args(...
        {@is_string, ', '; ...
        @is_string, ''; ...
        @is_string, ''; ...
        @is_string, ''; ...
        @is_string, ''}, varargin{:});

    n = numel(c);
    ol = length(gopening);
    cl = length(gclosing);
    l = ol + cl + n * length([opening closing]) ...
        + max([0, n - 1]) * length(sep) + cell_cum_numel(c);

    if l > 0
        ret = repmat(' ', 1, l);
        ret(1 : ol) = gopening;
        ret(l - cl + 1 : l) = gclosing;
        s = ol + 1;
        for k = 1 : n
            e = [opening c{k} closing];
            f = s + length(e) - 1;
            if k < n
                f = f + length(sep);
                ret(s : f) = [e sep];
            else
                ret(s : f) = e;
            endif
            s = f + 1;
        endfor
    else
        ret = '';
    endif

endfunction

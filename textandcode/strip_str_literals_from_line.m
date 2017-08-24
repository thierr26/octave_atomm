## Copyright (C) 2016-2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## stripped_str} =} strip_str_literals_from_line (@var{str})
##
## Remove string literals from code line.
##
## The recognized quote delimiters are those in the return string of
## @code{quote_delimiters} i.e., single quote (') and double quote (").
##
## Examples:
##
## @example
## @group
## strip_str_literals_from_line ('myFunctionCall ()')
##    @result{} "myFunctionCall ()"
## @end group
## @end example
##
## @example
## @group
## strip_str_literals_from_line ('myFunctionCall ("abc")')
##    @result{} "myFunctionCall ()"
## @end group
## @end example
##
## @example
## @group
## strip_str_literals_from_line ('myFunctionCall (["a" b "c"])')
##    @result{} "myFunctionCall ([ b ])"
## @end group
## @end example
##
## @seealso{quote_delimiters, strip_comment_from_line}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function stripped_str = strip_str_literals_from_line(str)

    quot = quote_delimiters;
    PrevNonBlankChar = ';';
    PrevCharIsBlank = false;
    strStart = 0;
    n = length(str);
    keep = true(1, n);
    for k = 1 : n

        if strStart == 0 ...
                && any(str(k) == quot) ...
                && (isempty(regexp(PrevNonBlankChar, '[\w})\]]', 'once')) ...
                || PrevCharIsBlank)
            # Current character is the opening quote delimiter for a string
            # literal. The
            # isempty(regexp(PrevNonBlankChar, '[\w})\]]', 'once'))
            # test avoids (hopefully) that the Matlab programming language
            # transposition operator ("'") is taken for a string literal
            # opening.

            q = str(k);
            qCount = 1;
            strStart = k;
        elseif strStart ~= 0 ...
                && str(k) == q ...
                && (k == n || (str(k + 1) ~= q && ~is_even(qCount)))
            # Current character is the closing quote for a string literal.

            keep(strStart : k) = false;
            strStart = 0;
        elseif strStart ~= 0 && str(k) == q
            # Current character is a quote in a string literal.

            qCount = qCount + 1;
        endif

        if isempty(regexp(str(k), '\s', 'once'))
            PrevNonBlankChar = str(k);
            PrevCharIsBlank = false;
        else
            PrevCharIsBlank = true;
        endif
    endfor

    stripped_str = str(keep);
    if numel(stripped_str) == 0
        stripped_str = '';
    endif

endfunction

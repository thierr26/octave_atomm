## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} strip_comment_from_line (@var{str})
## @deftypefnx {Function File} strip_comment_from_line (@var{str}, @var{@
## comment_leaders})
##
## Remove end of line comment from code line.
##
## @code{strip_comment_from_line} returns @var{str} with end of line comment
## (if any) removed.
##
## If @var{comment_leaders} (second argument) is not provided, then the end of
## line comment leaders are considered to be those of the Octave M-files, as
## returned by @code{m_comment_leaders}.  A string containing the characters to
## be used as end of line comment leaders can be provided instead.
##
## @seealso{m_comment_leaders, strip_comments_from_m}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function stripped_str = strip_comment_from_line(str, varargin)

    validated_mandatory_args({@is_string}, str);
    commentLeaders = validated_opt_args({@is_string, m_comment_leaders}, ...
        varargin{:});

    quot = quote_delimiters;
    commentLeaderFound = false;
    PrevNonBlankChar = ';';
    PrevCharIsBlank = false;
    isInStringLiteral = false;
    n = length(str);
    k = 0;
    while k < n && ~commentLeaderFound
        k = k + 1;

        if ~isInStringLiteral && ismember(str(k), commentLeaders)
            # Current character is the beginning of the end of line comment.

            commentLeaderFound = true;
        elseif ~isInStringLiteral ...
                && ismember(str(k), quot) ...
                && (~is_matched_by(PrevNonBlankChar, '[\w})\]]') ...
                || PrevCharIsBlank)
            # Current character is the opening quote delimiter for a string
            # literal. The ~is_matched_by(PrevNonBlankChar, '[\w})\]]') test
            # avoids (hopefully) that the Matlab programming language
            # transposition operator ("'") is taken for a string literal
            # opening.

            isInStringLiteral = true;
            q = str(k);
            qCount = 1;
        elseif isInStringLiteral ...
                && str(k) == q ...
                && (k == n || (str(k + 1) ~= q && ~is_even(qCount)))
            # Current character is the closing quote for a string literal.

            isInStringLiteral = false;
        elseif isInStringLiteral && str(k) == q
            # Current character is a quote in a string literal.

            qCount = qCount + 1;
        endif

        if ~is_matched_by(str(k), '\s')
            PrevNonBlankChar = str(k);
            PrevCharIsBlank = false;
        else
            PrevCharIsBlank = true;
        endif
    endwhile

    if ~commentLeaderFound
        stripped_str = str;
    elseif k == 1
        stripped_str = '';
    else
        stripped_str = str(1 : k - 1);
    endif

endfunction

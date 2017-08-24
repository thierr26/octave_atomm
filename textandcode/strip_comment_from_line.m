## Copyright (C) 2016-2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{@
## stripped_str}, @var{is_sloc}] =} strip_comment_from_line (@var{str})
## @deftypefnx {Function File} {[@var{@
## stripped_str}, @var{is_sloc}] =} strip_comment_from_line (@var{str}, @var{@
## comment_leaders})
## @deftypefnx {Function File} {[@var{@
## stripped_str}, @var{is_sloc}] =} strip_comment_from_line (@var{str}, @var{@
## comment_leaders}, @var{nocheck})
##
## Remove end of line comment from code line.
##
## @code{[@var{stripped_str}, @var{is_sloc}]
## = strip_comment_from_line (@var{str})} returns @var{str} with end of line
## comment (if any) removed.  @var{is_sloc} is a logical scalar set to true if
## @var{str} contains actual code (i.e.@ if @var{str} does not contain only
## white spaces characters and / or end of line comment).
##
## By default, the end of line comment leaders are considered to be those of
## the Octave M-files (i.e.@ "#" and "%", as returned by
## @code{m_comment_leaders}).
##
## Other end of line comment leaders can be specified via the optional second
## input argument.  If you want "#" and "'" to be used as comment leaders, use
## statement like
## @code{[@var{stripped_str}, @var{is_sloc}]
## = strip_comment_from_line (@var{str}, '#''')}.
##
## The user can also provide a third argument (@var{nocheck}), which must be a
## logical scalar. If it is true, then no argument checking is done.
##
## @seealso{m_comment_leaders, strip_comments_from_m, uncomment_line}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [stripped_str, is_sloc] = strip_comment_from_line(str, varargin)

    if nargin == 3 && is_logical_scalar(varargin{2}) && varargin{2}
        commentLeaders = varargin{1};
    else
        validated_mandatory_args({@is_string}, str);
        commentLeaders = validated_opt_args(...
            {@is_string, m_comment_leaders; ...
            @is_logical_scalar, false}, varargin{:});
    endif

    quot = quote_delimiters;
    commentLeaderFound = false;
    PrevNonBlankChar = ';';
    PrevCharIsBlank = false;
    isInStringLiteral = false;
    is_sloc = false;
    n = length(str);
    k = 0;
    while k < n && ~commentLeaderFound
        k = k + 1;

        if ~isInStringLiteral && any(str(k) == commentLeaders)
            # Current character is the beginning of the end of line comment.

            commentLeaderFound = true;
        elseif ~isInStringLiteral ...
                && any(str(k) == quot) ...
                && (isempty(regexp(PrevNonBlankChar, '[\w})\]]', 'once')) ...
                || PrevCharIsBlank)
            # Current character is the opening quote delimiter for a string
            # literal. The
            # isempty(regexp(PrevNonBlankChar, '[\w})\]]', 'once'))
            # test avoids (hopefully) that the Matlab programming language
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

        if isempty(regexp(str(k), '\s', 'once'))
            PrevNonBlankChar = str(k);
            PrevCharIsBlank = false;
            if ~commentLeaderFound
                is_sloc = true;
            endif
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

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{ret}, @var{fmt}, @var{ord}] =} outman_is_valid_progress_format (@var{@
## str})
##
## Validate an Outman progress indicator format string.
##
## @code{[@var{ret}, @var{fmt}, @var{@
## ord}] = outman_is_valid_progress_format (@var{str})} returns true in
## @var{ret} if @var{str} is a valid Outman progress indicator format string.
## If it is not the case, it returns false in @var{ret}.
##
## @var{str} is a valid Outman progress indicator format string if the
## following conditions are all fulfilled:
##
## @itemize @bullet
## @item
## The percent sign ("%") does not appear in @var{str} or appears followed by
## "msg", "percent" or another percent sign.
##
## @item
## "%msg" and "%percent" appear at most once in @var{str}.
## @end itemize
##
## The second output argument (@var{fmt}) is a template string that can be used
## with @code{fprintf}.  It is identical to @var{str} except that:
##
## @itemize @bullet
## @item
## The occurrence of "%msg" (if present) is substituted with a "%s" conversion
## specification.
##
## @item
## The occurrence of "%percent" (if present) is substituted with a "%3d"
## conversion specification.
## @end itemize
##
## The third output argument (@var{ord}) is a numerical vector having one of
## the following values:
##
## @itemize @bullet
## @item
## [] (empty vector): @var{fmt} does not contains any conversion specification.
##
## @item
## [1]: @var{fmt} contains contains only a "%s" conversion specification.
##
## @item
## [2]: @var{fmt} contains contains only a "%3d" conversion specification.
##
## @item
## [1 2]: @var{fmt} contains contains a "%s" conversion specification and a
## "%3d" conversion specification in that order.
##
## @item
## [2 1]: @var{fmt} contains contains a "%3d" conversion specification and a
## "%s" conversion specification in that order.
## @end itemize
##
## @seealso{fprintf, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [ret, fmt, ord] = outman_is_valid_progress_format(str)

    validated_mandatory_args({@is_string}, str);

    ret = false;
    fmt = '';
    ord = [];

    p1 = '%msg';
    s1 = '%s';
    p2 = '%percent';
    s2 = '%3d';

    pCPos = strfind(str, '%');
    pC2Pos = strfind(str, '%%');
    n = numel(pC2Pos);
    if n <= 1 || min(diff(pC2Pos) > 1)
        msgPos = strfind(str, p1);
        n1 = numel(msgPos);
        percentPos = strfind(str, p2);
        n2 = numel(percentPos);
        if n + n1 + n2 == numel(pCPos) - numel(pC2Pos) && n1 <= 1 && n2 <= 1
            ret = true;
            if n1 == 0 && n2 == 0
                ord = [];
            elseif n1 == 1 && n2 == 0
                ord = 1;
            elseif n1 == 0 && n2 == 1
                ord = 2;
            elseif msgPos < percentPos
                ord = [1 2];
            else
                ord = [2 1];
            endif
            fmt = strrep(strrep(str, p1, s1), p2, s2);
        endif
    endif

endfunction

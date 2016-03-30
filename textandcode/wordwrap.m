## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} wordwrap (@var{str}, @var{n})
##
## Word wrap a string.
##
## @code{wordwrap} cuts string @var{str} at spaces.  The resulting slices are
## returned in a cell array and have a length lower than or equal to @var{n}.
## In the particular case where @var{str} contains one or more slices of
## non-space characters that are longer than @var{n} characters, then one or
## more of the elements of the returned cell array will have a length greater
## than @var{n}.  Leading and trailing spaces are preserved.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function c = wordwrap(str, n)

    validated_mandatory_args({@is_string, @is_positive_integer_scalar}, ...
        str, n);

    if length(str) > n

        blankPos = regexp(str, ' +');
        nonBlankPos = regexp(str, '[^ ]+');

        if ~isempty(blankPos) && ~isempty(nonBlankPos)

            if blankPos(1) < nonBlankPos(1)
                blankPos = blankPos(2 : end);
            endif
            if ~isempty(blankPos) &&  blankPos(end) > nonBlankPos(end)
                blankPos = blankPos(1 : end - 1);
            endif

            if ~isempty(blankPos) && ~isempty(nonBlankPos)

                wrdEndPos = blankPos - 1;
                wrdCount = numel(wrdEndPos);
                c = cell(1, numel(blankPos) + 1);
                lnCount = 0;
                lnStrtPos = 1;
                lnStopWrdEndIdx = 1;
                while lnStopWrdEndIdx < wrdCount
                    if wrdEndPos(lnStopWrdEndIdx) >= lnStrtPos + n
                        if lnStopWrdEndIdx == 1 ...
                                || wrdEndPos(lnStopWrdEndIdx - 1) < lnStrtPos
                            idx = lnStopWrdEndIdx;
                            lnStopPos = wrdEndPos(idx);
                            lnStopWrdEndIdx = lnStopWrdEndIdx + 1;
                        else
                            idx = lnStopWrdEndIdx - 1;
                            lnStopPos = wrdEndPos(idx);
                        endif
                        lnCount = lnCount + 1;
                        c{lnCount} = str(lnStrtPos : lnStopPos);
                        lnStrtPos = nonBlankPos(idx + 1);
                    else
                        lnStopWrdEndIdx = lnStopWrdEndIdx + 1;
                    endif
                endwhile
                if length(str(lnStrtPos : end)) > n
                    lnCount = lnCount + 1;
                    c{lnCount} = str(lnStrtPos : wrdEndPos(end));
                    lnStrtPos = nonBlankPos(end);
                endif
                lnCount = lnCount + 1;
                c{lnCount} = str(lnStrtPos : end);

                c = c(1 : lnCount);

            else
                c = {str};
            endif
        else
            c = {str};
        endif
    else
        c = {str};
    endif

endfunction

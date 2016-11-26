## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## s} =} outman_update_progress_percent (@var{s1}, @var{idx}, @var{pos})
##
## Update an Outman progress indicator percentage.
##
## @code{outman_update_progress_percent} is used by Outman.  It is a very
## specific function and may not be useful for any other application.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = outman_update_progress_percent(s1, idx, pos)

    s = s1;

    startPos = s.progress.start(idx);
    finishPos = s.progress.finish(idx);

    # Make sure new position is in the position interval.
    newPos = min([max([startPos, pos]), finishPos]);

    newPercent = 100 * (newPos - startPos) / (finishPos - startPos);

    # Make sure percent value does not decrease.
    s.progress.percent(idx) = max([newPercent, s.progress.percent(idx)]);

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_update_progress_percent (@var{s1}, @var{@
## idx}, @var{pos})
##
## Update progress indicator percentage.
##
## @var{s1} is the state structure for application @code{outman}.  It contains
## arrays with information related to the progress indicators.  @var{idx} is
## the array index for a progress indicator and @var{pos} is the new progress
## position for the progress indicator.
##
## @code{outman_update_progress_percent} saturates @var{pos} to make sure it is
## not outside of the progress indicator outside bounds as defined in the call
## to the "init_progress" or "update_progress" commands of application
## @code{outman}.
##
## @code{outman_update_progress_percent} returns @var{s1} updated with the new
## progress percentage value for the progress indicator at array index
## @var{idx}.  @code{outman_update_progress_percent} also makes sure that the
## new percentage value is not lower than the old one.
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

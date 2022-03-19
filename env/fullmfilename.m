## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{str} =} fullmfilename ()
##
## Full name of the caller function file.
##
## When used from inside a function M-file, @code{fullmfilename} returns the
## full name of the M-file, including the extension.
##
## In Octave, @code{@var{str} = fullmfilename ()} is equivalent to
## @code{@var{str} = mfilename("fullpathext")}.
##
## @seealso{mfilename}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function str = fullmfilename

    stackStru = dbstack(1, '-completenames');

    if is_octave
        versionOctave = ver('octave');
        if strcmp(versionOctave.Version, '6.2.0')
            # Compensate for bug #60531
            # (https://savannah.gnu.org/bugs/index.php?60531).
            stackStru = stackStru(2 : end);
        endif;
    endif

    if ~isempty(stackStru)
        str = stackStru(1).file;
    else
        str = '';
    endif

endfunction

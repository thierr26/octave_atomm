## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -- Function File: backspace_supported ()
##
##     Return false if 'fprintf' may behave badly when there are
##     occurrences of backspaces ("\b") in the template string.
##
##     'backspace_supported' returns false if this is not Octave running
##     the function and the Java Virtual Machine (JVM) is not started,
##     which means that using FPRINTF with occurrences of backspace
##     characters ("\b") in the format string may not do what is expected.

## Author: Thierry Rascle <thierr26@free.fr>

function ret = backspace_supported

    persistent retMem;

    if isempty(retMem)
        retMem = is_octave || usejava('desktop');
    endif
    ret = retMem;

endfunction

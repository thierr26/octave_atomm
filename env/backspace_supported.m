## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -- Function File: RET = backspace_supported ()
##
##     True if "\b" supported in 'fprintf' template strings.
##
##     'RET = backspace_supported ()' returns false in RET if this is not
##     Octave running the function and the Java Virtual Machine (JVM) is
##     not started, which means that using 'fprintf' with occurrences of
##     backspace characters ("\b") in the format string may not do what is
##     expected.
##
##     See also: fprintf.

## Author: Thierry Rascle <thierr26@free.fr>

function ret = backspace_supported

    persistent retMem;

    if isempty(retMem)
        retMem = is_octave || usejava('desktop');
    endif
    ret = retMem;

endfunction

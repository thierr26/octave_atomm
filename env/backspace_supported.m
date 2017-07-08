## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} backspace_supported ()
##
## True if "\b" sequences are supported in 'fprintf' template strings.
##
## @code{@var{ret} = backspace_supported ()} returns false in @var{ret} if this
## is not Octave running the function and the Java Virtual Machine (JVM) is not
## started, which means that using @code{fprintf} with occurrences of
## @qcode{"\b"} in the template string may lead to unexpected results.
##
## @seealso{fprintf}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = backspace_supported

    persistent retMem;

    if isempty(retMem)
        retMem = is_octave || usejava('desktop');
    endif
    ret = retMem;

endfunction

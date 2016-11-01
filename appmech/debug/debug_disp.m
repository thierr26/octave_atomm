## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} debug_disp (@var{filename}, @var{x})
## @deftypefnx {Function File} debug_disp (@var{s}, @var{x})
##
## Append the output of @code{disp} to a debug log file, prepended with a
## timestamp.
##
## The debug log file name is determined based on the first argument.  If it is
## a string, then this string is used as debug log file name.  If it is a
## structure, then the "debug_log" field of this structure (if it exists) is
## used as debug log file name.  This allows you to pass directly the
## configuration structure of an application.  If the application has a
## "debug_log" configuration parameter, then it will be used as the debug log
## file name.  The recommended default value for the "debug_log" configuration
## parameter is the empty string.
##
## Note that an error is issued if the first argument is neither a string nor a
## structure or if the second argument is not a string.  In all other cases, no
## error is raised.
##
## The second argument @var{x} can be anything.  What is appended to the log
## file is the output of @code{disp(@var{x})}.
##
## @seealso{debug_msg, disp}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function debug_disp(f, x)

    if is_octave
        debug_msg(f, '%s', disp(x));
    else
        debug_msg(f, '%s', evalc('disp(x)'));
    endif

endfunction

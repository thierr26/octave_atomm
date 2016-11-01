## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} debug_msg (@var{filename}, @var{template}, ...)
## @deftypefnx {Function File} debug_msg (@var{s}, @var{template}, ...)
##
## Append a message to a debug log file, prepended with a timestamp.
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
## error is issued
##
## The second argument is a template (a format string) that is passed to
## @code{fprintf}, along with the optional arguments.
##
## @seealso{default_config, fprintf, is_string, isstruct, timestamp}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function debug_msg(f, template, varargin)

    validated_mandatory_args(...
        {@(x) is_string(x) || isstruct(x), @is_string}, f, template);

    field = 'debug_log';
    fileName = '';
    if is_string(f)
        fileName = f;
    elseif isfield(f, field)
        v = f.(field);
        if is_string(v)
            fileName = v;
        endif
    endif

    if ~isempty(fileName)

        # Open the file for appending (text mode).
        id = fopen(fileName, 'at');

        if id ~= -1
            fprintf(id, [timestamp ' ' template '\n'], varargin{1 : end});
            fclose(id);
        endif

    endif

endfunction

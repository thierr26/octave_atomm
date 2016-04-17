## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} timestamp2datenum (@var{str})
##
## Convert a timestamp string to a serial date number.
##
## Precisely, @code{timestamp2datenum} extracts the six integers of the
## timestamp string (representing the year, month, day, hour, minute, and
## seconds respectively) to make a date vector (similar to the output of
## @code{datevec}) and then passes the date vector to @code{datenum}.
##
## Note that no checking is done on the values of the integer members of the
## timestamp string.  They are passed as is to @code{datevec}.
##
## @var{str} can be a string (and in this case the return value is a scalar
## serial date number) or a cell vector of character arrays (and in this case
## the return value is an array of serial date numbers with the same shape).
##
## @seealso{datenum, datevec, is_string, is_cell_array_of_non_empty_strings,
## timestamp}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = timestamp2datenum(str)

    validated_mandatory_args({@is_valid_arg}, str);
    if ischar(str)
        ret = to_datenum(str);
    else
        if isrow(str)
            ret = cellfun(@to_datenum, str(:))';
        else
            ret = cellfun(@to_datenum, str(:));
        endif
    endif

endfunction

# -----------------------------------------------------------------------------

# Check the argument.

function ret = is_valid_arg(x)

    ret = (is_string(x) && looks_like_timestamp(x)) ...
        || (is_cell_array_of_non_empty_strings(x) && isvector(x) ...
        && all(cellfun(@looks_like_timestamp, x(:))));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# True for a string containing exactly 6 integers.  The first of them can have
# a minus sign.

function ret = looks_like_timestamp(str)

    ret = is_matched_by(str, '^[^\d]*-?(\d+[^\d]+){5}\d+[^\d]*$');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Convert timestamp string to serial date number.

function ret = to_datenum(str)

    firstIntegerPos = regexp(str, '\d', 'once');
    negativeFirstInteger ...
        = firstIntegerPos > 1 && str(firstIntegerPos - 1) == '-';
    v = str2double(regexp(str, '\d+', 'match')')';
    if negativeFirstInteger
        v(1) = -v(1);
    endif
    ret = datenum(v);

endfunction

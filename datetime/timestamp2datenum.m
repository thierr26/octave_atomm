## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{days} =} timestamp2datenum (@var{str})
##
## Convert a timestamp string to a serial date number.
##
## @code{@var{days} = timestamp2datenum (@var{str})} converts the timestamp
## string @var{str} to a serial date number.
##
## No check is done on @var{str}.  It is supposed to be a valid timestamp
## string i.e., a string that could have been returned by function
## @code{timestamp}.
##
## @var{str} can be a string (and in this case the return value is a scalar
## serial date number) or a cell vector of character arrays (and in this case
## the return value is an array of serial date numbers with the same shape).
##
## Example:
##
## @example
## @group
## timestamp2datenum ("2012-12-12T12:12:12")
##    @result{} 735215.508472222...
## @end group
## @end example
##
## @seealso{datenum, datevec, is_cell_array_of_non_empty_strings, is_string,
## timestamp}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function days = timestamp2datenum(str)

    validated_mandatory_args({@is_valid_arg}, str);
    if ischar(str)
        days = to_datenum(str);
    else
        if isrow(str)
            days = cellfun(@to_datenum, str(:))';
        else
            days = cellfun(@to_datenum, str(:));
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

function days = to_datenum(str)

    firstIntegerPos = regexp(str, '\d', 'once');
    negativeFirstInteger ...
        = firstIntegerPos > 1 && str(firstIntegerPos - 1) == '-';
    v = str2double(regexp(str, '\d+', 'match')')';
    if negativeFirstInteger
        v(1) = -v(1);
    endif
    days = datenum(v);

endfunction

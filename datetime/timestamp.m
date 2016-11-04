## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{str} =} timestamp ()
## @deftypefnx {Function File} {@var{str} =} timestamp (@var{date})
##
## Timestamp string.
##
## @code{@var{str} = timestamp ()} returns the current date as a string in
## @var{str}.  The format is like "2016-03-14T19:20:21".
##
## A different date can be provided as an argument.  It can be a scalar serial
## date number (see @code{datenum}) or a date vector (a row vector of length 6,
## see @code{datevec}).
##
## Examples:
##
## @example
## @group
## timestamp (735215.508472223)
##    @result{} "2012-12-12T12:12:12"
## @end group
## @end example
##
## @example
## @group
## timestamp ([2012 12 12 12 12 12])
##    @result{} "2012-12-12T12:12:12"
## @end group
## @end example
##
## @seealso{datenum, datestr, datevec, now, timestamp2datenum,
## timestamp2filename}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function str = timestamp(varargin)

    date = validated_opt_args({@is_valid_arg, now}, varargin{:});
    str = datestr(date, 'yyyy-mm-ddTHH:MM:SS');

endfunction

# -----------------------------------------------------------------------------

# True for a valid argument.

function ret = is_valid_arg(date)

    ret = isnumeric(date) ...
        && (isscalar(date) || (isrow(date) && numel(date) == 6));

endfunction

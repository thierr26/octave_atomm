## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} uncomment_line (@var{str})
## @deftypefnx {Function File} uncomment_line (@var{str}, @var{@
## comment_leaders})
##
## Uncomment a line.
##
## @code{uncomment_line(@var{str})} returns @var{str} uncommented (i.e. with
## the leading blanks and end of line comment leaders removed if any).
##
## If @var{comment_leaders} (second argument) is not provided, then the end of
## line comment leaders are considered to be those of the Octave M-files, as
## returned by @code{m_comment_leaders}.  A string containing the characters to
## be used as end of line comment leaders can be provided instead.
##
## @seealso{m_comment_leaders, strip_comment_from_line}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function uncommented_str = uncomment_line(str, varargin)

    validated_mandatory_args({@is_string}, str);
    commentLeaders = validated_opt_args({@is_string, m_comment_leaders}, ...
        varargin{:});

    if isempty(str)
        uncommented_str = '';
    else
        match = regexp(str, ['^(\s*[' commentLeaders ']+)+\s*'], ...
            'match', 'once');
        uncommented_str = str(length(match) + 1 : end);
    endif

endfunction

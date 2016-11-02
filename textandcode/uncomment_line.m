## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} uncomment_line (@var{str})
## @deftypefnx {Function File} {@var{ret} =} uncomment_line (@var{str}, @var{@
## comment_leaders})
##
## Uncomment a line.
##
## @code{@var{ret} = uncomment_line (@var{str})} returns uncommented @var{str}
## in @var{ret} (i.e.@ @var{str} with leading blanks and end of line comment
## leaders removed).
##
## By default, the end of line comment leaders are considered to be those of
## the Octave M-files (i.e.@ "#" and "%", as returned by
## @code{m_comment_leaders}).
##
## Other end of line comment leaders can be specified via the optional second
## input argument.  If you want "#" and "'" to be used as comment leaders, use
## statement like @code{@var{ret} = uncomment_line (@var{str}, '#''')}.
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

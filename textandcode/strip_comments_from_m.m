## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} strip_comments_from_m (@var{filename})
##
## Lines of M-file @var{filename} with comments removed.
##
## @code{strip_comments_from_m} returns a cell array of strings.  Each string
## is a line of the @var{filename} M-file with the comments removed.  For
## @code{strip_comments_from_m} the comments are "end of line comments" opened
## with a "%" or a "#" character or blocks of lines opened with a line
## containing "%@{" or "#@{" and closed with a line containing "%@}" or "#@}".
##
## @seealso{m_comment_leaders}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function c = strip_comments_from_m(filename)

    validated_mandatory_args({@is_non_empty_string}, filename);

    f = fopen(filename, 'r');
    c = textscan(f, '%s', 'Delimiter', '\n');
    c = c{1};
    fclose(f);

    isInBlockComment = false;
    for k = 1 : numel(c)

        if ~isempty(c{k})
            if ~isInBlockComment
                if is_matched_by(c{k}, ['^\s*[' m_comment_leaders ']{\s*$'])
                    # Current line is the beginning of a block comment.

                    isInBlockComment = true;
                else
                    # Current line is not in a block comment.

                    c{k} = strip_comment_from_line(c{k}, m_comment_leaders);
                endif
            endif

            if isInBlockComment
                if is_matched_by(c{k}, ['^\s*[' m_comment_leaders ']}\s*$'])
                    # Current line is the end of a block comment.

                    isInBlockComment = false;
                endif

                c{k} = '';
            endif
        endif

    endfor

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{c}, @var{n}, @var{sloc}] =} strip_comments_from_m (@var{filename})
## @deftypefnx {Function File} {@
## [@var{c}, @var{n}, @var{sloc}] =} strip_comments_from_m (@var{@
## filename}, @var{progress_id}, @var{progress})
## @deftypefnx {Function File} {@
## [@var{c}, @var{n}, @var{sloc}] =} strip_comments_from_m (@var{@
## filename}, @var{progress_id}, @var{progress}, @var{progress_fac})
##
## Lines of an M-file with comments removed.
##
## @code{[@var{c}, @var{n}, @var{sloc}]
## = strip_comments_from_m (@var{filename})} returns in @var{c} a cell array of
## strings.  Each string is a line of the @var{filename} M-file with the
## comments removed.  In this context the comments are "end of line comments"
## opened with a "%" or a "#" character or blocks of lines opened with a line
## containing "%@{" or "#@{" and closed with a line containing "%@}" or "#@}".
##
## The number of lines in the file is returned in @var{n}.
##
## The number of lines in the file that are not empty and don't contain only a
## comment is returned in @var{sloc}.
##
## Provide the optional arguments @var{progress_id} and @var{progress} if you
## want @code{strip_comments_from_m} to update an Outman progress indicator
## while processing the input file.  Provide both or none.
##
## @table @asis
## @item @var{progress_id}
## Outman progress indicator ID, as returned by a
## @code{outman('init_progress', @var{caller_id}, @var{start_position},
## @var{finish_position}, @var{task_description_string})} statement.
## @var{start_position} and @var{finish_position} are supposed to be amounts of
## bytes to be processed (@var{start_position} is typically 0 and
## @var{finish_position} the cumulated byte size of files to be processed using
## @code{strip_comments_from_m}).
##
## @item @var{progress}
## Number of bytes already processed.  It is the caller's responsability to
## make sure @var{progress} is up to date before calling
## @code{strip_comments_from_m} to process a particular file.
## @end table
##
## An additional optional argument (@var{progress_fac}) can be provided to
## express that the processing done on the input file by
## @code{strip_comments_from_m} is not the only one and that other processings
## are done elsewhere.  For example, if the cost in time of processing done by
## @code{strip_comments_from_m} is one third of the cost in time of the global
## processing, set @var{progress_fac} to 1/3.  Use of argument
## @var{progress_fac} may imply the need for a more complex computation of
## argument @var{progress} by the caller to avoid a "stucked progress
## indicator" effect.
##
## @seealso{m_comment_leaders, outman, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [c, n, sloc] = strip_comments_from_m(filename, varargin)

    validated_mandatory_args({@is_non_empty_string}, filename);
    mustUpdateProgress = nargin > 1;
    if mustUpdateProgress
        progress_id = varargin{1};
        progress = varargin{2};
        if nargin > 3
            progress_fac = varargin{3};
        else
            progress_fac = 1;
        endif
        oId = outman_connect_and_config_if_master;
    endif

    # Read the file.
    cc = text_file_lines(filename);

    n = numel(cc);
    c = cell(n, min([1 n]));
    c(:) = {''};

    isInBlockComment = false;
    for k = 1 : n

        if mustUpdateProgress
            progress = progress + progress_fac * (length(cc{k}) + 1);
                                                  # +1 is for the EOL sequence.
        endif

        if ~isempty(cc{k})
            if ~isInBlockComment
                if is_matched_by(cc{k}, ['^\s*[' m_comment_leaders ']{\s*$'])
                    # Current line is the beginning of a block comment.

                    isInBlockComment = true;
                else
                    # Current line is not in a block comment.

                    c{k} = strip_comment_from_line(cc{k}, m_comment_leaders);
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

        if mustUpdateProgress && mod(k, 15) == 0
            outman('update_progress', oId, progress_id, progress);
        endif

    endfor

    sloc = sum(cellfun(@(x) ~isempty(x) && ~is_matched_by(x, '^\s*$'), c));

    if mustUpdateProgress
        outman('disconnect', oId);
    endif

endfunction

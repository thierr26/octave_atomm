## Copyright (C) 2016-2017 Thierry Rascle <thierr26@free.fr>
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
## @deftypefnx {Function File} {@
## [@var{c}, @var{n}, @var{sloc}] =} strip_comments_from_m (@var{@
## filename}, @var{progress_id}, @var{progress}, @var{progress_fac}, @var{@
## nocheck})
##
## Lines of an M-file with comments removed.
##
## @code{[@var{c}, @var{n}, @var{sloc}]
## = strip_comments_from_m (@var{filename})} returns in @var{c} a cell array of
## strings.  Every string is a line of the @var{filename} M-file with the
## comments removed.  In this context the comments are "end of line comments"
## opened with a "%" or a "#" character or blocks of lines opened with a line
## containing "%@{" or "#@{" and closed with a line containing "%@}" or "#@}".
##
## The number of lines in the file is returned in @var{n}.
##
## The indices of lines in the file that are not empty and don't contain only a
## comment are returned in array @var{sloc}.
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
## @var{finish_position} the cumulative byte size of files to be processed
## using @code{strip_comments_from_m}).
##
## @item @var{progress}
## Number of bytes already processed.  It is the caller's responsibility to
## make sure @var{progress} is up to date before calling
## @code{strip_comments_from_m} to process a particular file.
## @end table
##
## An additional optional argument (@var{progress_fac}) can be provided to
## express that the processing done on the input file by
## @code{strip_comments_from_m} is not the only one and that other jobs are
## done in other functions.  For example, if the cost in time of processing
## done by @code{strip_comments_from_m} is one third of the cost in time of the
## global processing, set @var{progress_fac} to 1/3.  Use of argument
## @var{progress_fac} may imply the need for a more complex computation of
## argument @var{progress} by the caller to avoid a "stuck progress indicator"
## effect.
##
## The user can also provide a fifth argument (@var{nocheck}), which must be a
## logical scalar. If it is true, then no argument checking is done.
##
## @seealso{m_comment_leaders, outman, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [c, n, sloc] = strip_comments_from_m(filename, varargin)

    if nargin == 5 && is_logical_scalar(varargin{4}) && varargin{4}
        progress_id = varargin{1};
        progress = varargin{2};
        progress_fac = varargin{3};
        mustUpdateProgress = true;
    else
        validated_mandatory_args({@is_non_empty_string}, filename);
        [progress_id, progress, progress_fac] = validated_opt_args(...
            {@is_num_scalar, -1; ...
            @is_num_scalar, 0; ...
            @is_num_scalar, 1; ...
            @is_logical_scalar, false}, varargin{:});
        mustUpdateProgress = nargin > 1;
    endif
    oId = outman_connect_and_config_if_master_c(mustUpdateProgress);

    # Read the file.
    try
        cc = text_file_lines(filename);
    catch err
        outman_disconnect_and_rethrow(mustUpdateProgress, oId, err);
    end_try_catch

    n = numel(cc);
    c = cell(n, min([1 n]));
    c(:) = {''};
    sloc = zeros(n, min([1 n]));
    slocCount = 0;

    isInBlockComment = false;
    for k = 1 : n

        if mustUpdateProgress
            progress = progress + progress_fac * (length(cc{k}) + 1);
                                                  # +1 is for the EOL sequence.
        endif

        isSLOC = false;
        if ~isempty(cc{k})
            if ~isInBlockComment
                if is_matched_by(cc{k}, ['^\s*[' m_comment_leaders ']{\s*$'])
                    # Current line is the beginning of a block comment.

                    isInBlockComment = true;
                else
                    # Current line is not in a block comment.

                    [c{k}, isSLOC] = strip_comment_from_line(...
                        cc{k}, m_comment_leaders, true);
                    if isSLOC
                        slocCount = slocCount + 1;
                        sloc(slocCount) = k;
                    endif
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

        outman_c(mustUpdateProgress && mod(k, 15) == 0, ...
            'update_progress', oId, progress_id, progress);

    endfor

    sloc = sloc(1 : slocCount);

    outman_c(mustUpdateProgress, 'disconnect', oId);

endfunction

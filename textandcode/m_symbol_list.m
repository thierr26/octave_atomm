## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{c}, @var{n}, @var{sloc}] =} m_symbol_list (@var{filename})
## @deftypefnx {Function File} {@
## [@var{c}, @var{n}, @var{sloc}] =} m_symbol_list (@var{filename}, @var{@
## progress_id}, @var{progress})
##
## List of symbols (identifiers) appearing in an M-file.
##
## @code{[@var{c}, @var{n}, @var{sloc}] = m_symbol_list (@var{filename})}
## returns in @var{c} a sorted cell array of strings containing the symbols
## (identifiers) appearing in M-file @var{filename}.  Symbols recognized as
## keywords using @code{iskeyword} are excluded from the returned cell array.
##
## The number of lines in the file is returned in @var{n}.
##
## The number of lines in the file that are not empty and don't contain only a
## comment is returned in @var{sloc}.
##
## Provide the optional arguments @var{progress_id} and @var{progress} if you
## want @code{m_symbol_list} to update an Outman progress indicator while
## processing the input file.  Provide both or none.
##
## @table @asis
## @item @var{progress_id}
## Outman progress indicator ID, as returned by a
## @code{outman('init_progress', @var{caller_id}, @var{start_position},
## @var{finish_position}, @var{task_description_string})} statement.
## @var{start_position} and @var{finish_position} are supposed to be amounts of
## bytes to be processed (@var{start_position} is typically 0 and
## @var{finish_position} the cumulated byte size of files to be processed using
## @code{m_symbol_list}).
##
## @item @var{progress}
## Number of bytes already processed.  It is the caller's responsability to
## make sure @var{progress} is up to date before calling @code{m_symbol_list}
## to process a particular file.
## @end table
##
## Function @code{compute_dependencies} is an example of a use of
## @code{m_symbol_list} with the optional arguments.
##
## @seealso{compute_dependencies, iskeyword, outman,
## outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [c, n, sloc] = m_symbol_list(filename, varargin)

    mustUpdateProgress = nargin > 1;
    if mustUpdateProgress
        progress_id = varargin{1};
        progress = varargin{2};
        oId = outman_connect_and_config_if_master;
    endif

    if mustUpdateProgress
        stripCommentTimeFraction = 0.53;
        MeanCharCountInComments = 15; # Mean character count in comment or
                                      # empty lines (arbitrary estimation).
        stripStrLiteralTimeFraction = 0.43;
        stripCommentsFromMOptArgs ...
            = {progress_id, progress, stripCommentTimeFraction};
    else
        stripCommentsFromMOptArgs = {};
    endif
    [l, n, sloc] = strip_comments_from_m(filename, ...
        stripCommentsFromMOptArgs{:});
    if mustUpdateProgress
        remainingBytes = cell_cum_numel(l) + n;
        progress = progress + stripCommentTimeFraction * (remainingBytes ...
            + MeanCharCountInComments * (n - sloc)); # Compensation for lost
                                                     # bytes in the strip
                                                     # comments process.
    endif

    for k = 1 : n

        if mustUpdateProgress
            if numel(l{k}) ~= 0
                progress = progress ...
                    + stripStrLiteralTimeFraction * numel(l{k});
            else
                # l{k} is empty possibly because it was a comment line.
                progress = progress ...
                    + stripStrLiteralTimeFraction * MeanCharCountInComments;
            endif
        endif

        l{k} = strip_str_literals_from_line(l{k});

        if mustUpdateProgress && mod(k, 15) == 0
            outman('update_progress', oId, progress_id, progress);
        endif

    endfor

    # It seems impossible that the number of symbols in an M-File is greater
    # than the numbers of characters (not counting end of lines, comments and
    # string literals) divided by two.
    c = cell(1, ceil(cell_cum_numel(l) / 2));

    level = 0;
    for k = 1 : n

        if mustUpdateProgress
            if numel(l{k}) ~= 0
                progress = progress ...
                    + stripStrLiteralTimeFraction * numel(l{k});
            else
                # l{k} is empty possibly because it was a comment line.
                progress = progress ...
                    + stripStrLiteralTimeFraction * MeanCharCountInComments;
            endif
        endif

        lineSymbols = regexp(l{k}, '\W', 'split');
        lineSymbols = lineSymbols(~cellfun(@isempty, lineSymbols));
        for kSymb = 1 : numel(lineSymbols)
            symb = lineSymbols{kSymb};
            if ~is_scalar_num_or_log_literal(symb) ...
                    && ~iskeyword(symb) && ~ismember(symb, c(1 : level))
                level = level + 1;
                c{level} = symb;
            endif
        endfor

        if mustUpdateProgress && mod(k, 15) == 0
            outman('update_progress', oId, progress_id, progress);
        endif

    endfor

    c = sort(c(1 : level));

    if mustUpdateProgress
        outman('disconnect', oId);
    endif

endfunction

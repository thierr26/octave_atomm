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
## @var{finish_position} the cumulative byte size of files to be processed
## using @code{m_symbol_list}).
##
## @item @var{progress}
## Number of bytes already processed.  It is the caller's responsibility to
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

    validated_mandatory_args({@is_non_empty_string}, filename);
    [progress_id, progress] = validated_opt_args(...
            {@is_num_scalar, -1; @is_num_scalar, 0}, varargin{:});
    mustUpdateProgress = nargin > 1;
    oId = outman_connect_and_config_if_master_c(mustUpdateProgress);

    if mustUpdateProgress
        stripCommentTimeFraction = 0.53;
        MeanCharCountInComments = 15; % Mean character count in comment or
                                      % empty lines (arbitrary estimation).
        stripStrLiteralTimeFraction = 0.43;
        stripCommentsFromMOptArgs ...
            = {progress_id, progress, stripCommentTimeFraction};
    else
        stripCommentsFromMOptArgs = {};
    endif
    try
        [l, n, sloc] = strip_comments_from_m(filename, ...
            stripCommentsFromMOptArgs{:});
    catch err
        outman_disconnect_and_rethrow(mustUpdateProgress, oId, err);
    end_try_catch
    if mustUpdateProgress
        remainingBytes = cell_cum_numel(l) + n;
        progress = progress + stripCommentTimeFraction * (remainingBytes ...
            + MeanCharCountInComments * (n - sloc)); % Compensation for lost
                                                     % bytes in the strip
                                                     % comments process.
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

        outman_c(mustUpdateProgress && mod(k, 15) == 0, ...
            'update_progress', oId, progress_id, progress);

    endfor

    # It seems impossible that the number of symbols in an M-file is greater
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

        # Remove the trailing triple dots.
        if numel(l{k} >= 3) && strcmp(l{k}(end - 2 : end), '...')
            l{k} = l{k}(1 : end - 3);
        endif

        # Remove the decimal marks with preceding digits.
        precedingDigitsPos = regexp(l{k}, '\W[0-9]+\.');
        for kk = numel(precedingDigitsPos) : -1 : 1
            decimalMarkPos = strfind(l{k}(precedingDigitsPos(kk) : end), '.');
            l{k} = [l{k}(1 : precedingDigitsPos(kk) - 1) ...
                l{k}(precedingDigitsPos(kk) + decimalMarkPos(1) : end)];
        endfor

        # The remaining dots are very likely to be from "dot notations".

        # Remove the field names.
        l{k} = strjoin(regexp(l{k}, '\. *\w+', 'split'));

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

        outman_c(mustUpdateProgress && mod(k, 15) == 0, ...
            'update_progress', oId, progress_id, progress);

    endfor

    c = sort(c(1 : level));
    if numel(c) == 0
        c = {};
    endif

    outman_c(mustUpdateProgress, 'disconnect', oId);

endfunction

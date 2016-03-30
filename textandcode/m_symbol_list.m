## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} m_symbol_list (@var{filename})
##
## List of symbols (identifiers) appearing in an M-file.
##
## @code{m_symbol_list} returns a sorted cell array of strings containing the
## symbols (identifiers) appearing in M-file @var{filename}.  Symbols
## recognized as keywords using @code{iskeyword} are excluded from the returned
## cell array.
##
## @seealso{iskeyword}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function c = m_symbol_list(filename)

    l = strip_comments_from_m(filename);
    n = numel(l);
    for k = 1 : n
        l{k} = strip_str_literals_from_line(l{k});
    endfor

    # It seems impossible that the number of symbols in an M-File is greater
    # than the numbers of characters (not counting end of lines, comments and
    # string literals) divided by two.
    c = cell(1, ceil(cell_cum_numel(l) / 2));

    level = 0;
    for k = 1 : n
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
    endfor

    c = sort(c(1 : level));

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} compute_dependencies (@var{s})
##
## Grow the output of @code{find_m_toolboxes} with declared dependencies.
##
## @code{compute_dependencies} takes as argument a structure output by
## @code{find_m_toolboxes} or @code{read_declared_dependencies} and add the
## following fields:
##
## @table @asis
## @item mfilelinecount
## Cell array (same shape as the toolboxpath field of the input structure) of
## numerical arrays (same shape as the corresponding element in the mfiles
## field of the input structure) containing the number of lines of the M-files.
##
## @item mfilesloc
## Cell array (same shape as the toolboxpath field of the input structure) of
## numerical arrays (same shape as the corresponding element in the mfiles
## field of the input structure) containing the number of software lines of
## code of the M-files (number of lines that are not blank and don't contain
## only a comment).
##
## @item privatemfilelinecount
## Cell array (same shape as the privatemfiles field of the input structure) of
## numerical arrays (same shape as the corresponding element in the
## privatemfiles field of the input structure) containing the number of lines
## of the private M-files.
##
## @item privatemfilesloc
## Cell array (same shape as the privatemfiles field of the input structure) of
## numerical arrays (same shape as the corresponding element in the
## privatemfiles field of the input structure) containing the number of
## software lines of code of the M-files (number of lines that are not blank
## and don't contain only a comment).
##
## @item external_funcs
## Cell array (same shape as the toolboxpath field of the input structure) of
## cell arrays of strings containing the names of the functions from other
## toolboxes that are called by the toolbox.
##
## @item comp_dep
## Cell array (same shape as the toolboxpath field of the input structure) of
## numerical arrays containing indices to the toolboxpath field of the input
## structure.  The presence of an index means that the corresponding toolbox
## seems to be a dependency (i.e. a toolbox from which at least one function is
## used).
## @end table
##
## @code{compute_dependencies} uses Outman for progress indication and
## messaging.
##
## @seealso{find_m_toolboxes, outman, read_declared_dependencies}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = compute_dependencies(s1)

    s = validated_mandatory_args({@valid_arg}, s1);

    nTB = numel(s.toolboxpath);
    s.mfilelinecount = cell(1, nTB);
    s.mfilesloc = cell(1, nTB);
    s.privatemfilelinecount = cell(1, numel(s.privatemfiles));
    s.privatemfilesloc = cell(1, numel(s.privatemfiles));
    s.external_funcs = cell(1, nTB);
    s.comp_dep = cell(1, nTB);

    cumBytes = sum(cellfun(@(x) sum(x), s.mfilebytes)) ...
        + sum(cellfun(@(x) sum(x), s.privatemfilebytes));

    oId = outman_connect_and_config_if_master;
    pId = outman('init_progress', oId, 0, cumBytes, ...
        'Computing dependencies...');
    p = 0;

    publicFunc = list_public_funcs(s);
    homony = cell(1, numel(publicFunc));
    homonyCount = 0;

    % Loop over the toolboxes.
    for kTB = 1 : nTB
        h = false(1, nTB);

        symbL = {};
        s.mfilelinecount{kTB} = zeros(1, numel(s.mfiles{kTB}));
        s.mfilesloc{kTB} = zeros(1, numel(s.mfiles{kTB}));

        % Loop over the toolbox public functions.
        for k = 1 : numel(s.mfiles{kTB})
            [~, ~, ext] = fileparts(s.mfiles{kTB}{k});
            if strcmp(ext, '.m')
                filename = fullfile(s.toolboxpath{kTB}, s.mfiles{kTB}{k});
                [symb, n, sloc] = m_symb_l(filename, oId, pId, p);
                s.mfilelinecount{kTB}(k) = n;
                s.mfilesloc{kTB}(k) = sloc;
            endif
            symbL = unique([symbL symb]);
            p = p + s.mfilebytes{kTB}(k);
            outman('update_progress', oId, pId, p);
        endfor

        hf = false(1, numel(publicFunc));
        for symb = symbL
            if ~is_private_func(s, kTB, symb{1})
                process_non_private_symb
            endif
        endfor

        kP = s.privateidx(kTB);
        if kP ~= 0

            symbL = {};
            s.privatemfilelinecount{kTB} ...
                = zeros(1, numel(s.privatemfiles{kP}));
            s.privatemfilesloc{kTB} = zeros(1, numel(s.privatemfiles{kP}));

            % Loop over the toolbox private functions.
            for k = 1 : numel(s.privatemfilebytes{kP})
                [~, ~, ext] = fileparts(s.privatemfiles{kP}{k});
                if strcmp(ext, '.m')
                    filename = fullfile(fullfile(s.toolboxpath{kTB}, ...
                        s.privatesubdir), s.privatemfiles{kP}{k});
                    [symb, n, sloc] = m_symb_l(filename, oId, pId, p);
                    s.privatemfilelinecount{kP}(k) = n;
                    s.privatemfilesloc{kP}(k) = sloc;
                endif
                symbL = unique([symbL symb]);
                p = p + s.privatemfilebytes{kP}(k);
                outman('update_progress', oId, pId, p);
            endfor

            for symb = symbL
                process_non_private_symb
            endfor

        endif
        s.comp_dep{kTB} = find(h);
        s.external_funcs{kTB} = publicFunc(hf);
    endfor

    outman('terminate_progress', oId, pId);
    outman('disconnect', oId);

# -----------------------------------------------------------------------------

    # Processing for a symbol which is not a private function of the toolbox
    # being processed.

    function process_non_private_symb

        [isPub, idxPub] = ismember(symb{1}, publicFunc);
        if isPub
            [~, tBIdx] = is_public_func(s, symb{1});
            if numel(tBIdx) == 1 && tBIdx ~= kTB
                hf(idxPub) = true;
                h(tBIdx) = true;
            elseif numel(tBIdx) > 1 ...
                    && ~ismember(symb{1}, homony(1 : homonyCount))
                homonyCount = homonyCount + 1;
                homony{homonyCount} = symb{1};
                outman('errorf', oId, ...
                    'Multiple toolboxes have a function "%s":', symb{1});
                for k = 1 : numel(tB)
                    outman('printf', oId, '\t%s', s.toolboxpath{kTB});
                endfor
            endif
        endif

    endfunction

endfunction

# -----------------------------------------------------------------------------

# Check the input structure.

function ret = valid_arg(s)

    ret = isstruct(s);

    ret = ret && isfield(s, 'toolboxpath');
    ret = ret && iscellstr(s.toolboxpath) ...
        && (isempty(s.toolboxpath) || isrow(s.toolboxpath));

    ret = ret && isfield(s, 'mfiles');
    ret = ret && iscell(s.mfiles) && isrow(s.mfiles) ...
        && (isempty(s.mfiles) ...
            || cellfun(@(x) iscellstr(x) && isrow(x), s.mfiles));
    ret = ret && numel(s.toolboxpath) == numel(s.mfiles);

    ret = ret && isfield(s, 'mfilebytes');
    ret = ret && iscell(s.mfilebytes) && isrow(s.mfilebytes) ...
        && (isempty(s.mfilebytes) ...
            || cellfun(@(x) is_integer_vect(x) && min(x) >= 0, s.mfilebytes));

    if ret
        for k = 1 : numel(s.toolboxpath)
            ret = ret && numel(s.mfiles{k}) == numel(s.mfilebytes{k});
        endfor
    endif

    ret = ret && isfield(s, 'privateidx') && is_integer_vect(s.privateidx) ...
        && isrow(s.privateidx) ...
        && (isempty(s.privateidx) || min(s.privateidx) >= 0) ...
        && numel(s.privateidx) == numel(s.toolboxpath);
    privateIdxNZ = s.privateidx(s.privateidx ~= 0);
    privateIdxNZU = unique(privateIdxNZ);
    ret = ret && numel(privateIdxNZ) == numel(privateIdxNZU) ...
        && all(diff(privateIdxNZU) == 1);

    ret = ret && isfield(s, 'privatemfiles');
    ret = ret && iscell(s.privatemfiles) && isrow(s.privatemfiles) ...
        && (isempty(s.privatemfiles) ...
            || cellfun(@(x) iscellstr(x) && isrow(x), s.privatemfiles));
    ret = ret && numel(s.privatemfiles) == numel(privateIdxNZ);

    ret = ret && isfield(s, 'privatemfilebytes');
    ret = ret && iscell(s.privatemfilebytes) && isrow(s.privatemfilebytes) ...
        && (isempty(s.privatemfiles) ...
            || cellfun(@(x) is_integer_vect(x) && min(x) >= 0, ...
                s.privatemfilebytes));

    if ret && ~isempty(privateIdxNZU)
        for k = privateIdxNZU
            ret = ret ...
                && numel(s.privatemfiles{k}) == numel(s.privatemfilebytes{k});
        endfor
    endif

    ret = ret ...
        && isfield(s, 'privatesubdir') && is_non_empty_string(s.privatesubdir);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return the list of the public functions of all the toolboxes. Duplicates are
# not removed.

function ret = list_public_funcs(s);

    ret = cell(1, cell_cum_numel(s.mfiles));
    n = 0;
    for k = 1 : numel(s.toolboxpath)
        nn = numel(s.mfiles{k});
        ret(n + 1 : n + nn) = cellfun(@(x) x(1 : strfind(x, '.') - 1), ...
            s.mfiles{k}, 'UniformOutput', false);
        n = n + nn;
    endfor

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Call function m_symbol_list and issue an error message if the file has zero
# lines or zero symbols.

function [c, n, sloc] = m_symb_l(filename, o_id, p_id, p)

    [c, n, sloc] = m_symbol_list(filename, o_id, p_id, p);
    if sloc == 0
        outman('errorf', o_id, ...
            '%s does not contain any software lines of code', filename);
    elseif n == 0
        outman('errorf', o_id, '%s is empty', filename);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# True if filename is a plausible file name for a function with name func_name
# (i.e. if filename is func_name followed by ".m" or ".p").

function ret = valid_file_name(filename, func_name)

    ret = any(strcmp(filename, {[func_name '.m'], [func_name '.p']}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# True if func_name is the name of a private function of the toolbox with index
# toolbox_idx in s.toolboxpath.

function ret = is_private_func(s, toolbox_idx, func_name)

    ret = false;
    if s.privateidx(toolbox_idx) ~= 0
        ret = any(cellfun(@(x) valid_file_name(x, func_name), ...
            s.privatemfiles{s.privateidx(toolbox_idx)}));
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return true in ret if func_name is the name of a public function in at least
# one of the toolboxes in s. toolbox_idx is a numerical array containing the
# indices of those toolboxes in s.toolboxpath.

function [ret, toolbox_idx] = is_public_func(s, func_name);

    ret = false;
    f = false(1, numel(s.toolboxpath));
    for k = 1 : numel(f)
        f(k) = any(cellfun(@(x) valid_file_name(x, func_name), s.mfiles{k}));
        ret = ret || f(k);
    endfor
    toolbox_idx = find(f);

endfunction

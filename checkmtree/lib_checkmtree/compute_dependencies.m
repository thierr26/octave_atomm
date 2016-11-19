## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} compute_dependencies (@var{s1})
##
## Grow output of @code{find_m_toolboxes} with computed dependencies.
##
## The argument @var{s1} is supposed to have been returned by function
## @code{find_m_toolboxes} or function @code{read_declared_dependencies}.
## @code{@var{s} = compute_dependencies (@var{s1})} returns in @var{s}
## @var{s1} with some fields added:
##
## @table @asis
## @item @qcode{"mfilelinecount"}
## Cell array (same shape as the @qcode{"toolboxpath"} field of the input
## structure) of numerical arrays (same shape as the corresponding element in
## the @qcode{"mfiles"} field of the input structure) containing the number of
## lines of the function file.
##
## @item @qcode{"mfilesloc"}
## Cell array (same shape as the @qcode{"toolboxpath"} field of the input
## structure) of numerical arrays (same shape as the corresponding element in
## the @qcode{"mfiles"} field of the input structure) containing the number of
## software lines of code of the function files (number of lines that are not
## blank and don't contain only a comment).
##
## @item @qcode{"mfileexternalfuncs"}
## Cell array (same shape as the @qcode{"toolboxpath"} field of the input
## structure) of cell arrays (same shape as the corresponding element in the
## @qcode{"mfiles"} field of the input structure) containing the names of the
## functions from other toolboxes that are called by the function file.
##
## @item @qcode{"privatemfilelinecount"}
## Cell array (same shape as the @qcode{"privatemfiles"} field of the input
## structure) of numerical arrays (same shape as the corresponding element in
## the @qcode{"privatemfiles"} field of the input structure) containing the
## number of lines of the private function files.
##
## @item @qcode{"privatemfilesloc"}
## Cell array (same shape as the @qcode{"privatemfiles"} field of the input
## structure) of numerical arrays (same shape as the corresponding element in
## the @qcode{"privatemfiles"} field of the input structure) containing the
## number of software lines of code of the function files (number of lines that
## are not blank and don't contain only a comment).
##
## @item @qcode{"privatemfileexternalfuncs"}
## Cell array (same shape as the @qcode{"privatemfiles"} field of the input
## structure) of cell arrays (same shape as the corresponding element in the
## @qcode{"privatemfiles"} field of the input structure) containing the names
## of the functions from other toolboxes that are called by the private
## function file.
##
## @item @qcode{"externalfuncs"}
## Cell array (same shape as the @qcode{"toolboxpath"} field of the input
## structure) of cell arrays of strings containing the names of the functions
## from other toolboxes that are called by the toolbox.
##
## @item @qcode{"comp_dep"}
## Cell array (same shape as the @qcode{"toolboxpath"} field of the input
## structure) of numerical arrays containing indices to the
## @qcode{"toolboxpath"} field of the input structure.  The presence of an
## index means that the corresponding toolbox seems to be a dependency (i.e.@
## a toolbox from which at least one function is used).
## @end table
##
## @code{read_declared_dependencies} uses Outman for progress indication and
## messaging.  Please run @code{help outman} for more information about Outman.
##
## @seealso{find_m_toolboxes, outman, read_declared_dependencies}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = compute_dependencies(s1)

    s = validated_mandatory_args({@is_find_m_toolboxes_s}, s1);

    nTB = numel(s.toolboxpath);
    nP = numel(s.privatemfiles);
    s.mfilelinecount = cell(1, nTB);
    s.mfilesloc = cell(1, nTB);
    s.mfileexternalfuncs = cell(1, nTB);
    s.privatemfilelinecount = cell(1, nP);
    s.privatemfilesloc = cell(1, nP);
    s.privatemfileexternalfuncs = cell(1, nP);
    s.externalfuncs = cell(1, nTB);
    s.comp_dep = cell(1, nTB);

    cumBytes = m_files_cum_byte_size(s);

    mFilt = m_file_filters ('m_lang_only');
    mExt = file_ext(mFilt{1});

    oId = outman_connect_and_config_if_master;
    pId = outman('init_progress', oId, 0, cumBytes, ...
        'Computing dependencies...');
    p = 0;

    publicFunc = list_public_funcs(s);
    nPF = numel(publicFunc);
    homony = cell(1, nPF);
    homonyCount = 0;

    # Loop over the toolboxes.
    for kTB = 1 : nTB
        nM = numel(s.mfiles{kTB});
        h = false(1, nTB);

        symbL = {};
        s.mfilelinecount{kTB} = zeros(1, nM);
        s.mfilesloc{kTB} = zeros(1, nM);
        s.mfileexternalfuncs{kTB} = cell(1, nM);

        # Loop over the toolbox public functions.
        for k = 1 : nM
            symb = {};
            if strcmp(file_ext(s.mfiles{kTB}{k}), mExt)
                filename = fullfile(s.toolboxpath{kTB}, s.mfiles{kTB}{k});
                [symb, n, sloc] = m_symb_l(filename, pId, p);
                s.mfilelinecount{kTB}(k) = n;
                s.mfilesloc{kTB}(k) = sloc;
                s.mfileexternalfuncs{kTB}{k} = symb;
                p = p + s.mfilebytes{kTB}(k);
                outman('update_progress', oId, pId, p);
            endif
            symbL = unique([symbL symb]);
            if numel(symbL) == 0
                symbL = {};
            endif
        endfor

        hF = false(1, nPF);
        for symb = symbL
            if ~is_private_func(s, kTB, symb{1})
                process_non_private_symb;
            endif
        endfor

        nPM = 0;
        kP = s.privateidx(kTB);
        if kP ~= 0
            nPM = numel(s.privatemfiles{kP});

            symbL = {};
            s.privatemfilelinecount{kP} = zeros(1, nPM);
            s.privatemfilesloc{kP} = zeros(1, nPM);
            s.privatemfileexternalfuncs{kP} = cell(1, nPM);

            # Loop over the toolbox private functions.
            for k = 1 : nPM
                symb = {};
                if strcmp(file_ext(s.privatemfiles{kP}{k}), mExt)
                    filename = fullfile(fullfile(s.toolboxpath{kTB}, ...
                        s.privatesubdir), s.privatemfiles{kP}{k});
                    [symb, n, sloc] = m_symb_l(filename, pId, p);
                    s.privatemfilelinecount{kP}(k) = n;
                    s.privatemfilesloc{kP}(k) = sloc;
                    s.privatemfileexternalfuncs{kP}{k} = symb;
                    p = p + s.privatemfilebytes{kP}(k);
                    outman('update_progress', oId, pId, p);
                endif
                symbL = unique([symbL symb]);
                if numel(symbL) == 0
                    symbL = {};
                endif
            endfor

            for symb = symbL
                process_non_private_symb;
            endfor

        endif
        s.comp_dep{kTB} = find(h);
        s.externalfuncs{kTB} = publicFunc(hF);

        # Loop over the toolbox public functions.
        for k = 1 : nM
            if strcmp(file_ext(s.mfiles{kTB}{k}), mExt)
                [~, idx] = ismember(s.externalfuncs{kTB}, ...
                    s.mfileexternalfuncs{kTB}{k});
                s.mfileexternalfuncs{kTB}{k} ...
                    = s.mfileexternalfuncs{kTB}{k}(idx(idx ~= 0));
            else
                s.mfileexternalfuncs{kTB}{k} = {};
            endif
        endfor

        # Loop over the toolbox private functions if any.
        for k = 1 : nPM
            if strcmp(file_ext(s.privatemfiles{kP}{k}), mExt)
                [~, idx] = ismember(s.externalfuncs{kTB}, ...
                    s.privatemfileexternalfuncs{kP}{k});
                s.privatemfileexternalfuncs{kP}{k} ...
                    = s.privatemfileexternalfuncs{kP}{k}(idx(idx ~= 0));
            else
                s.privatemfileexternalfuncs{kP}{k} = {};
            endif
        endfor

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
                hF(idxPub) = true;
                h(tBIdx) = true;
            elseif numel(tBIdx) > 1 ...
                    && ~ismember(symb{1}, homony(1 : homonyCount))
                homonyCount = homonyCount + 1;
                homony{homonyCount} = symb{1};
                outman('errorf', oId, ...
                    'Multiple toolboxes have a function "%s":', symb{1});
                for kk = tBIdx
                    outman('printf', oId, '\t%s', s.toolboxpath{kk});
                endfor
            endif
        endif

    endfunction

endfunction

# -----------------------------------------------------------------------------

# Return the list of the public functions of all the toolboxes. Duplicates are
# not removed.

function ret = list_public_funcs(s)

    ret = cell(1, cell_cum_numel(s.mfiles));
    n = 0;
    for k = 1 : numel(s.toolboxpath)
        nn = numel(s.mfiles{k});
        ret(n + 1 : n + nn) = strip_dot_suffix(s.mfiles{k});
        n = n + nn;
    endfor

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Call function m_symbol_list and issue an error message if the file has zero
# lines or zero symbols.

function [c, n, sloc] = m_symb_l(filename, p_id, p)

    [c, n, sloc] = m_symbol_list(filename, p_id, p);

    template = '';
    if n == 0
        template = '%s is empty';
    elseif sloc == 0
        template = '%s does not contain any software lines of code';
    endif
    if ~isempty(template)
        oId = outman_connect_and_config_if_master;
        outman('errorf', oId, template, filename);
        outman('disconnect', oId);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# True if filename is a plausible file name for a function with name func_name
# (i.e. if filename is func_name followed by ".m" or ".p").

function ret = valid_file_name(filename, func_name)

    ret = strncmp([func_name '.'], filename, length(func_name) + 1);

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

function [ret, toolbox_idx] = is_public_func(s, func_name)

    ret = false;
    f = false(1, numel(s.toolboxpath));
    for k = 1 : numel(f)
        f(k) = any(cellfun(@(x) valid_file_name(x, func_name), s.mfiles{k}));
        ret = ret || f(k);
    endfor
    toolbox_idx = find(f);

endfunction

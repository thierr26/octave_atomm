## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_find_m_toolboxes_s (@var{s})
##
## Return true if @var{s} looks like a structure returned by
## @code{find_m_toolboxes}.
##
## @seealso{find_m_toolboxes}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_find_m_toolboxes_s(s)

    ret = isstruct(s);

    ret = ret && isfield(s, 'toolboxpath') ...
        && is_set_of_non_empty_strings(s.toolboxpath) ...
        && all(cellfun(@(x) strcmp(x, absolute_path(x)), s.toolboxpath));

    ret = ret && isfield(s, 'depfile') ...
        && is_cell_array_of_strings(s.depfile) ...
        && same_shape(s.toolboxpath, s.depfile);

    ret = ret && isfield(s, 'mfiles');
    ret = ret && iscell(s.mfiles) ...
        && all(cellfun(@is_set_of_non_empty_strings, s.mfiles)) ...
        && same_shape(s.mfiles, s.toolboxpath);

    ret = ret && isfield(s, 'mfilebytes');
    ret = ret && iscell(s.mfilebytes) ...
        && same_shape(s.mfilebytes, s.toolboxpath) ...
        && all(cellfun(@(x) is_integer_vect(x) && min(x) >= 0, s.mfilebytes));

    if ret
        for k = 1 : numel(s.toolboxpath)
            ret = ret && same_shape(s.mfiles{k}, s.mfilebytes{k});
        endfor
    endif

    ret = ret && isfield(s, 'privateidx') ...
        && same_shape(s.privateidx, s.toolboxpath) ...
        && (isempty(s.privateidx) ...
            || (is_integer_vect(s.privateidx) && min(s.privateidx) >= 0));

    privateIdxNZ = s.privateidx(s.privateidx > 0);
    if isempty(privateIdxNZ)
        privateIdxNZ = [];
    endif
    privateIdxNZU = unique(privateIdxNZ);
    privateCount = numel(privateIdxNZU);
    ret = ret && numel(privateIdxNZ) == privateCount ...
        && all(diff(privateIdxNZU) == 1);

    ret = ret && isfield(s, 'privatemfiles');
    ret = ret && iscell(s.privatemfiles) ...
        && all(cellfun(@is_set_of_non_empty_strings, s.privatemfiles)) ...
        && same_shape(s.privatemfiles, privateIdxNZ);

    ret = ret && isfield(s, 'privatemfilebytes');
    ret = ret && iscell(s.privatemfilebytes) ...
        && same_shape(s.privatemfilebytes, privateIdxNZ) ...
        && all(cellfun(@(x) is_integer_vect(x) && min(x) >= 0, ...
            s.privatemfilebytes));

    for k = 1 : privateCount
        ret = ret && same_shape(s.privatemfiles{k}, s.privatemfilebytes{k});
    endfor

    ret = ret ...
        && isfield(s, 'privatesubdir') && is_non_empty_string(s.privatesubdir);

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_find_files_s(s)

    ret = true;

    if ~isstruct(s)
        ret = false;
    elseif ~isfield(s, 'dir') || ~iscell(s.dir) ...
            || ~is_set_of_non_empty_strings(s.dir) ...
            || ~all(cellfun(@(x) strcmp(x, absolute_path(x)), s.dir))
        ret = false;
    elseif ~isfield(s, 'first_file_idx') ...
            || ~isnumeric(s.first_file_idx) ...
            || ~isreal(s.first_file_idx) ...
            || any(isnan(s.first_file_idx) | isinf(s.first_file_idx)) ...
            || ~all(floor(s.first_file_idx) == ceil(s.first_file_idx)) ...
            || numel(s.first_file_idx) ~= numel(s.dir)
        ret = false;
    elseif ~isfield(s, 'last_file_idx') ...
            || ~isnumeric(s.last_file_idx) ...
            || ~isreal(s.last_file_idx) ...
            || any(isnan(s.last_file_idx) | isinf(s.last_file_idx)) ...
            || ~all(floor(s.last_file_idx) == ceil(s.last_file_idx)) ...
            || numel(s.last_file_idx) ~= numel(s.dir)
        ret = false;
    elseif ~isfield(s, 'file') || ~iscell(s.file) ...
            || (~is_cell_array_of_non_empty_strings(s.file) ...
            && ~isempty(s.file))
        ret = false;
    elseif ~isfield(s, 'dir_idx') ...
            || ~isnumeric(s.dir_idx) ...
            || ~isreal(s.dir_idx) ...
            || any(isnan(s.dir_idx) | isinf(s.dir_idx)) ...
            || ~all(floor(s.dir_idx) == ceil(s.dir_idx)) ...
            || numel(s.dir_idx) ~= numel(s.file)
        ret = false;
    elseif ~isfield(s, 'bytes') ...
            || ~isnumeric(s.bytes) ...
            || ~isreal(s.bytes) ...
            || any(isnan(s.bytes) | isinf(s.bytes)) ...
            || ~all(floor(s.bytes) == ceil(s.bytes)) ...
            || numel(s.bytes) ~= numel(s.file)
        ret = false;
    elseif ~isfield(s, 'datenum') ...
            || ~isfloat(s.datenum) ...
            || numel(s.datenum) ~= numel(s.file)
        ret = false;
    endif

    if ret
        v1 = s.first_file_idx;
        v2 = s.last_file_idx;
        last_file_idx_zero = v2 == 0;
        if ~all(v1(last_file_idx_zero) == 1)
            ret = false;
        else
            v1(last_file_idx_zero) = 0;
            [vs1, i1] = sort(v1);
            [vs2, i2] = sort(v2);
            zero1 = vs1 == 0;
            zero2 = vs2 == 0;

            if ~isequal(i1, i2) ...
                    || ~all(vs1 >= 0) ...
                    || ~all(vs2 >= 0) ...
                    || ~all(zero1 == zero2) ...
                    || ~all(vs2(~zero2) >= vs1(~zero1)) ...
                    || (~isempty(vs2) && max(vs2) > numel(s.file)) ...
                    || ~all(s.dir_idx > 0) ...
                    || ~all(s.bytes >= 0) ...
                    || (~isempty(s.dir_idx) ...
                        && ~isequal(sort(wio_consec_duplicates(s.dir_idx)), ...
                        unique(s.dir_idx))) ...
                    || (~isempty(s.dir_idx) && max(s.dir_idx) > numel(s.dir))
                ret = false;
            endif
        endif
    endif

endfunction

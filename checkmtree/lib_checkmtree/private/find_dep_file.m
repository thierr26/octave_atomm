## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function dep_file_name = find_dep_file(directory, varargin)

    isPrivate = validated_opt_args({@is_logical_scalar, false}, varargin{:});

    c = {'dependencies', 'dependencies.txt'};
    s = find_files_empty_s;
    for k = 1 : numel(c)
        s = find_files(s, directory, c{k}, 1, ignored_dir_list, true);
    endfor

    dep_file_name = '';
    if ~isempty(s.file)
        if isPrivate
            oId = outman_connect_and_config_if_master;
            outman('errorf', oId, ...
                'At least one dependency file found in %s', directory);
            outman('errorf', oId, ['Private directories should not ' ...
                'contain dependency files']);
            outman('disconnect', oId);
        elseif numel(s.file) > 1
            oId = outman_connect_and_config_if_master;
            outman('errorf', oId, ...
                'Multiple dependency files found in toolbox %s', directory);
            for k = 1 : numel(s.file)
                outman('errorf', oId, '- %s', s.file{k});
            endfor
            outman('errorf', oId, ...
                'Doing as if %s was the only one', s.file{1});
            outman('disconnect', oId);
        endif
        dep_file_name = s.file{1};
    endif

endfunction

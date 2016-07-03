## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} read_declared_dependencies (@var{s})
##
## Grow the output of @code{find_m_toolboxes} with declared dependencies.
##
## @code{read_declared_dependencies} takes as argument a structure output by
## @code{find_m_toolboxes} or @code{compute_dependencies} and add the following
## field:
##
## @table @asis
## @item decl_dep
## Cell array (same shape as the toolboxpath field of the input structure) of
## numerical arrays containing indices to the toolboxpath field of the input
## structure.  The presence of an index means that the corresponding toolbox is
## a declared dependency (i.e. a dependency read in a dependency file).
## Please see the documentation for @code{checkmtree} for more information
## about dependency files.
## @end table
##
## @code{read_declared_dependencies} uses Outman for progress indication and
## messaging.
##
## @seealso{compute_dependencies, find_m_toolboxes, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = read_declared_dependencies(s1)

    s = validated_mandatory_args({@is_find_m_toolboxes_s}, s1);

    nTb = numel(s.toolboxpath);
    mn = min([1 nTb]);
    s.decl_dep = cell(mn, nTb);

    oId = outman_connect_and_config_if_master;
    pId = outman('init_progress', oId, 0, nTb, ...
        'Reading declared dependencies...');

    # Loop over toolboxes.
    for kTB = 1 : nTb
        if ~isempty(s.depfile{kTB})

            # Read dependency file for current toolbox and remove comments.
            depFileName = fullfile(s.toolboxpath{kTB}, s.depfile{kTB});
            try
                c = strip_comments_from_m(depFileName);
            catch
                outman('errorf', oId, 'Cannot read %s', depFileName);
                c = {};
            end_try_catch

            s.decl_dep{kTB} = zeros(1, numel(c));
            dup = false(1, nTb);

            # Loop over the lines of the dependency file.
            declDepIdx = 0;
            for k = 1 : numel(c)
                matchIdx = toolbox_index(s, c{k}, kTB);
                if isscalar(matchIdx) ...
                        && any(s.decl_dep{kTB}(1 : declDepIdx) == matchIdx)
                    if ~dup(matchIdx)
                        outman('warningf', oId, ['In %s, toolbox "%s" is ' ...
                            'mentioned multiple times'], depFileName, c{k});
                        dup(matchIdx) = true;
                    endif
                elseif isscalar(matchIdx)
                    declDepIdx = declDepIdx + 1;
                    s.decl_dep{kTB}(declDepIdx) = matchIdx;
                endif
            endfor

            s.decl_dep{kTB} = s.decl_dep{kTB}(1 : declDepIdx);
        endif
        outman('update_progress', oId, pId, kTB);
    endfor

    outman('terminate_progress', oId, pId);
    outman('disconnect', oId);

endfunction

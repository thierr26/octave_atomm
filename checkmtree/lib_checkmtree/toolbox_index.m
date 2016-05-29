## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{index} =} toolbox_index (@var{s}, @var{@
## toolbox_designation})
## @deftypefnx {Function File} {@var{index} =} toolbox_index (@var{s}, @var{@
## toolbox_designation}, @var{k})
##
## Find the index of a toolbox in the output structure of
## @code{find_m_toolboxes}.
##
## @code{toolbox_index} takes as argument a structure @var{s} output by
## @code{find_m_toolboxes} and a toolbox designation (string
## @var{toolbox_designation}).  A toolbox designation is the kind of
## information found in dependency files.  Please see the documentation for
## function @code{checkmtree} for more details.
##
## The return value @var{index} is the index of the toolbox in the field
## "toolboxpath" of @var{s}.
##
## @var{index} is empty if the toolbox is not found in @var{s}.  In this case,
## an Outman warning message is issued (except if @var{toolbox_designation} is
## empty or blank).
##
## @var{index} is a vector with more than one component if
## @var{toolbox_designation} is ambiguous.  In this case, an Outman error
## message is issued.
##
## Optional argument @var{k} defaults to 0.  If greater than zero, it is
## considered to be the index in the field "toolboxpath" of @var{s} of the
## toolbox declaring @var{toolbox_designation} as a dependency.  Providing
## @var{k} will cause an Outman error message to be issued if @var{index} is
## scalar and equals @var{k}.
##
## @seealso{checkmtree, find_m_toolboxes, outman, read_declared_dependencies}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function index = toolbox_index(s, toolbox_designation, varargin)

    validated_mandatory_args(...
        {@(x) isstruct(x) ...
            && isfield(x, 'toolboxpath') ...
            && isfield(x, 'depfile') ...
            && iscellstr(x.toolboxpath) ...
            && (isempty(x.toolboxpath) || isrow(x.toolboxpath)) ...
            && iscellstr(x.depfile) && isrow(x.depfile) ...
            && numel(x.toolboxpath) == numel(x.depfile), ...
            @is_non_empty_string}, s, toolbox_designation);
    k = validated_opt_args({@is_num_scalar, 0}, varargin{:});

    if length(toolbox_designation) > 0 ...
            && ~is_matched_by(toolbox_designation, '^\s*$')

        if ispc
            wrongFileSep = '\';
        else
            wrongFileSep = '/';
        endif
        tD = strrep(toolbox_designation, wrongFileSep, filesep);

        if strcmp(tD, absolute_path(tD))
            # Toolbox designation is an absolute path.

            f = strcmp(tD, s.toolboxpath);
        else
            # Toolbox designation is a relative path.

            f = is_matched_by(s.toolboxpath, ['\' filesep tD '$']);
        endif
        matchCount = sum(f);
        index = find(f);
        if matchCount > 1
            [flag, idx] = ismember(k, index);
            if flag
                index(idx) = [];
                matchCount = matchCount - 1;
            endif
        endif
        if matchCount == 1 && index == k
            oId = outman_connect_and_config_if_master;
            outman('errorf', oId, ['%s must not be a declared dependency ' ...
                'of itself'], s.toolboxpath{k});
            outman('disconnect', oId);
        else
            if matchCount > 1
                oId = outman_connect_and_config_if_master;
                if k > 0
                    outman('errorf', oId, ['In %s, "%s" is ambiguous. It ' ...
                        'can be one of:'], dep_file_name, toolbox_designation);
                else
                    outman('errorf', oId, ['"%s" is ambiguous. It can be ' ...
                        'one of:'], toolbox_designation);
                endif
                for kk = index
                    outman('printf', oId, '\t%s', s.toolboxpath{kk});
                endfor
                outman('disconnect', oId);
            elseif matchCount == 0
                oId = outman_connect_and_config_if_master;
                if k > 0
                    outman('warningf', oId, ['In %s, toolbox "%s" is ' ...
                        'mentioned but is not in the analysed tree'], ...
                        dep_file_name, toolbox_designation);
                else
                    outman('warningf', oId, ['toolbox "%s" is not in the ' ...
                        'analysed tree'], toolbox_designation);
                endif
                outman('disconnect', oId);
            endif
        endif

    else
        index = [];
    endif

# -----------------------------------------------------------------------------

    # Full path to the dependency file.

    function str = dep_file_name
        str = fullfile(s.toolboxpath{k}, s.depfile{k});
    endfunction

endfunction

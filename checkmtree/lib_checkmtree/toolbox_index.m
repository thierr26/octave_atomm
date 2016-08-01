## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{index}, @var{s}] =} toolbox_index (@var{@
## s1}, @var{toolbox_designation})
## @deftypefnx {Function File} {[@var{index}, @var{s}] =} toolbox_index (@var{@
## s1}, @var{toolbox_designation}, @var{k})
## @deftypefnx {Function File} {[@var{index}, @var{s}] =} toolbox_index (@var{@
## s1}, @var{toolbox_designation}, @var{k}, @var{no_absent_of_tree_warning})
## @deftypefnx {Function File} {[@var{index}, @var{s}] =} toolbox_index (@var{@
## s1}, @var{toolbox_designation}, @var{k}, @var{@
## no_absent_of_tree_warning}, @var{nocheck})
##
## Find the index of a toolbox in the output structure of
## @code{find_m_toolboxes}.
##
## @code{toolbox_index} takes as argument a structure @var{s1} output by
## @code{find_m_toolboxes} and a toolbox designation (string
## @var{toolbox_designation}).  A toolbox designation is the kind of
## information found in dependency files.  Please see the documentation for
## function @code{checkmtree} for more details.
##
## The return value @var{index} is the index of the toolbox in the field
## "toolboxpath" of @var{s1}.
##
## @var{index} is empty if the toolbox is not found in @var{s1}.  In this case,
## an Outman warning message is issued, unless @var{no_absent_of_tree_warning}
## is provided and set to true.
##
## @var{index} is a vector with more than one component if
## @var{toolbox_designation} is ambiguous.  In this case, an Outman error
## message is issued.
##
## Optional argument @var{k} defaults to 0.  If greater than zero, it is
## considered to be the index in the field "toolboxpath" of @var{s1} of the
## toolbox declaring @var{toolbox_designation} as a dependency.  Providing
## @var{k} will cause an Outman error message to be issued if @var{index} is
## scalar and equals @var{k}.
##
## If @var{nocheck} is provided and is true, then no argument checking is done.
##
## The second output argument is identical to @var{s}, except that the field
## "toolboxdesig" may be created or updated.  The field "toolboxdesig" is used
## to store the toolbox designation and speed up the function when the same
## designation is provided again. Of course, the @var{s} output argument must
## be provided back as the @var{s1} input argument on the next call to benefit
## from the "toolboxdesig" field.
##
## @seealso{checkmtree, find_m_toolboxes, outman, read_declared_dependencies}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [index, s] = toolbox_index(s1, toolbox_designation, varargin)

    if arg_check_needed(s1, toolbox_designation, varargin{:})
        [s, ~, k, no_absent_of_tree_warning] ...
            = check_args(s1, toolbox_designation, varargin{:});
    else
        s = s1;
        [k, no_absent_of_tree_warning] = varargin{:};
    endif

    index = [];
    if isfield(s, 'toolboxdesig')
        index = find(strcmp(toolbox_designation, s.toolboxdesig));
    endif

    if numel(index) ~= 1

        if ispc
            wrongFileSep = '/';
        else
            wrongFileSep = '\';
        endif
        tD = strrep(toolbox_designation, wrongFileSep, filesep);

        if strcmp(tD, absolute_path(tD))
            # Toolbox designation is an absolute path.

            f = strcmp(tD, s.toolboxpath);
        else
            # Toolbox designation is a relative path.

            f = is_matched_by(s.toolboxpath, ...
                ['\' filesep strrep(tD, filesep, ['\' filesep]) '$']);
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
            elseif matchCount == 0 && ~no_absent_of_tree_warning
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
            elseif matchCount == 1
                if ~isfield(s, 'toolboxdesig')
                    s.toolboxdesig = cell(1, numel(s.toolboxpath));
                    s.toolboxdesig(:) = {''};
                endif
                s.toolboxdesig{index} = toolbox_designation;
            endif
        endif
    endif

# -----------------------------------------------------------------------------

    # Full path to the dependency file.

    function str = dep_file_name
        str = fullfile(s.toolboxpath{k}, s.depfile{k});
    endfunction

endfunction

# -----------------------------------------------------------------------------

# Return true if argument checking is needed.

function ret = arg_check_needed(varargin)

    nocheckPos = 5;
    ret = nargin < nocheckPos || ~is_logical_scalar(varargin{nocheckPos}) ...
        || ~varargin{nocheckPos};

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check the arguments.

function [s, tb_desig, k, no_absent_of_tree_warning] ...
    = check_args(s1, toolbox_designation, varargin)

    if nargin > 5
        error('Too many arguments');
    endif

    [s, tb_desig] = validated_mandatory_args({@is_find_m_toolboxes_s, ...
            @is_non_empty_string}, s1, toolbox_designation);
    if isfield(s1, 'toolboxdesig') ...
            && (~is_cell_array_of_strings(s1.toolboxpath) ...
            || ~same_shape(s1.toolboxpath, s1.toolboxdesig))
        error('Invalid toolboxdesig field in input structure');
    end
    [k, no_absent_of_tree_warning, ~] = validated_opt_args(...
        {@is_integer_scalar, 0; ...
        @is_logical_scalar, false; ...
        @is_logical_scalar, false}, varargin{:});

endfunction

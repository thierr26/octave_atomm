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
## no_absent_of_tree_warning}, @var{no_check})
##
## Locate a toolbox in the output structure of @code{find_m_toolboxes}.
##
## @code{@var{index} = toolbox_index (@var{s1}, @var{toolbox_designation})}
## returns in @var{index} a vector of indices to the cell array field
## @qcode{"toolboxpath"} of the @var{s1} structure, which is supposed to have
## been returned by function @code{find_m_toolboxes}.
##
## @code{@var{s1}.toolboxpath (@var{index})} returns a cell array containing
## the absolute path to the toolboxes found by @code{find_m_toolboxes} that
## could have been designated as @var{toolbox_designation} in a dependency
## file.  Please see the documentation for Toolman (run @code{help toolman})
## for all the details about the dependency files.
##
## In the particular case where none of the toolboxes found by
## @code{find_m_toolboxes} could have been designated as
## @var{toolbox_designation}, @var{index} is empty and a warning message is
## issued using Outman.  Please run @code{help outman} for more information
## about Outman.
##
## In the particular case where more than one of the toolboxes found by
## @code{find_m_toolboxes} could have been designated as
## @var{toolbox_designation}, @var{index} contains multiple values and an error
## message is issued using Outman to tell the user that
## @var{toolbox_designation} is ambiguous.
##
## The third argument (@var{k}) is optional and defaults to zero.  If it is
## provided and is greater than zero, then it is considered to be the index in
## the cell array field @qcode{"toolboxpath"} of the @var{s1} structure of a
## toolbox that has a dependency file that mentions @var{toolbox_designation}.
## This allows @code{toolbox_index} to be used as a dependency locating
## function.
##
## @code{@var{index} = toolbox_index (@var{s1}, @var{@
## toolbox_designation}), @var{k})} (with @var{k} > 0) does the same as
## @code{@var{index} = toolbox_index (@var{s1}, @var{toolbox_designation})}
## except that:
##
## @itemize @bullet
## @item
## In the particular case where @var{index} is scalar and equals to @var{k},
## then an error message is issued using Outman to inform the user that the
## dependency file of a toolbox should not mention this same toolbox (i.e.@ a
## toolbox cannot be a dependency of itself).
##
## @item
## In the particular case where @var{index} would have been of a length greater
## than 1 and would have contain a component equalling @var{k}, then this
## component is removed from @var{index}.  This a way of not finding a toolbox
## as a dependency of itself.
## @end itemize
##
## The fourth argument (@var{no_absent_of_tree_warning}) is optional and
## defaults to false.  If it is provided and set to true, then no warning
## message is issued when an empty @var{index} is returned.
##
## The fifth argument (@var{no_check}) is optional and defaults to false.  If
## it is provided and set to true, then no argument checking is done.  This
## speeds up the function.  Of course, this implies that the input arguments
## must be safe.
##
## The second output argument (@var{s}) is identical to @var{s1}, except that
## the field @qcode{"toolboxdesig"} may be created or updated.  The field
## @qcode{"toolboxdesig"} is used to store the toolbox designation and speed up
## the function when the same designation is provided again.  Of course, the
## @var{s} output argument must be provided back as the @var{s1} input argument
## on the next call to benefit from the @qcode{"toolboxdesig"} field.
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
                    outman('printf', oId, '  %s', s.toolboxpath{kk});
                endfor
                outman('disconnect', oId);
            elseif matchCount == 0 && ~no_absent_of_tree_warning
                oId = outman_connect_and_config_if_master;
                if k > 0
                    outman('warningf', oId, ['In %s, toolbox "%s" is ' ...
                        'mentioned but is not in the analysed tree ' ...
                        'or does not contain any function files'], ...
                        dep_file_name, toolbox_designation);
                else
                    outman('warningf', oId, ['toolbox "%s" is not in the ' ...
                        'analysed tree or does not contain any function ' ...
                        'files'], toolbox_designation);
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

function [s, tb_desig, k, no_absent_of_tree_warning] = check_args(...
        s1, toolbox_designation, varargin)

    if nargin > 5
        error('Too many arguments');
    endif

    [s, tb_desig] = validated_mandatory_args({@is_find_m_toolboxes_s, ...
            @is_non_empty_string}, s1, toolbox_designation);
    if isfield(s1, 'toolboxdesig') ...
            && (~is_cell_array_of_strings(s1.toolboxpath) ...
            || ~same_shape(s1.toolboxpath, s1.toolboxdesig))
        error('Invalid toolboxdesig field in input structure');
    endif
    [k, no_absent_of_tree_warning, ~] = validated_opt_args(...
        {@is_integer_scalar, 0; ...
        @is_logical_scalar, false; ...
        @is_logical_scalar, false}, varargin{:});

endfunction

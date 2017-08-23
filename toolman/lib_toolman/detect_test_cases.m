## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} detect_test_cases (@var{s1}, @var{@
## tctbregexp}, @var{tcregexp})
##
## Grow output of @code{find_m_toolboxes} with test case information.
##
## The argument @var{s1} is supposed to have been returned by function
## @code{find_m_toolboxes} or function @code{read_declared_dependencies}.
## @code{@var{s} = detect_test_cases (@var{s1}, @var{tctbregexp}, @var{@
## tcregexp})} returns in @var{s} @var{s1} with two fields added:
##
## @table @asis
## @item @qcode{"testcases"}
## Cell array (same shape as the @qcode{"toolboxpath"} field of the input
## structure) of numerical arrays containing indices to the mfiles field of the
## input structure.  The presence of an index means that the corresponding
## M-file is a test case M-file.
##
## @item @qcode{"testcasetb"}
## Numerical array (same shape as the @qcode{"toolboxpath"} field of the input
## structure) of zero values or indices to the @qcode{"toolboxpath"} field. A
## non zero value means that the corresponding toolbox is the test case
## toolbox.
## @end table
##
## @var{tctbregexp} is a regular expression used to check whether a toolbox
## base name is a test case toolbox name or not. An example of valid value for
## @var{tctbregexp} is "^test_".
##
## @var{tcregexp} is a regular expression used to check whether a M-file name
## is a test case name or not. An example of valid value for @var{tcregexp} is
## "^test_".
##
## @code{detect_test_cases} uses Outman for progress indication and
## messaging.
##
## @seealso{find_m_toolboxes, outman, read_declared_dependencies}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = detect_test_cases(s1, tctbregexp, tcregexp)

    s = validated_mandatory_args({@is_find_m_toolboxes_s}, s1);

    n = numel(s.toolboxpath);
    s.testcases = cell(1, n);
    s.testcasetb = zeros(1, n);
    oId = outman_connect_and_config_if_master;
    pId = outman('init_progress', oId, 0, n, 'Detecting the test cases...');
    for k = 1 : n
        [idx, parentIdx] = test_cases_indices(s, tctbregexp, tcregexp, k);
        s.testcases{k} = idx;
        if ~isempty(s.testcases{k})
            if s.testcasetb(parentIdx) ~= 0
                    outman('errorf', oId, ['%s looks like a test case ' ...
                        'toolbox for %s, but %s already has %s as test ' ...
                        'case toolbox. %s ignored.'], ...
                        s.toolboxpath{k}, ...
                        s.toolboxpath{parentIdx}, ...
                        s.toolboxpath{parentIdx}, ...
                        s.toolboxpath{s.testcasetb(parentIdx)}, ...
                        s.toolboxpath{k});
            else
                s.testcasetb(parentIdx) = k;
            endif
        endif
        outman('update_progress', oId, pId, k);
    endfor
    outman('disconnect', oId);

endfunction

# -----------------------------------------------------------------------------

# Return an empty vector in idx if the toolbox at index toolbox_idx in the
# application state structure is not a test case toolbox, otherwise returns the
# indices of the test case M-files of the toolbox (indices in the component
# toolbox_idx of the mfiles field) of the application state structure. If idx
# is returned non empty, then the second output argument can be used as the
# index of the "parent" toolbox in the toolboxpath field of the application
# state structure.

function [idx, parent_tb_idx] = test_cases_indices(...
        s, tctbregexp, tcregexp, toolbox_idx)

    [parentTb, name] = fileparts(s.toolboxpath{toolbox_idx});
    isTestCaseTb = is_matched_by(name, tctbregexp);

    if isTestCaseTb
        [flag, parent_tb_idx] = ismember(parentTb, s.toolboxpath);
        isTestCaseTb = flag;
    else
        parent_tb_idx = 0;
    endif

    directory = parentTb;
    while isTestCaseTb && directory(end) ~= filesep
        [directory, name] = fileparts(directory);
        isTestCaseTb = ~is_matched_by(name, tctbregexp);
    endwhile

    if isTestCaseTb
        idx = find(is_matched_by(...
            s.mfiles{toolbox_idx}, tcregexp));
    else
        idx = [];
    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_appmech ()
##
## Test the appmech toolbox.
##
## @code{test_appmech} tests the appmech toolbox and returns a structure.  This
## structure is a structure returned by @code{run_test_case} and can be used as
## argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_appmech

    # Declare the test routines.
    testRoutine = {...
        @no_appdata_begin, ...
        @apply_config_args_fail_invalid_appname, ...
        @apply_config_args_fail_invalid_locked, ...
        @apply_config_args_empty_1, ...
        @apply_config_args_empty_2, ...
        @apply_config_args_no_arg, ...
        @apply_config_args_two_args, ...
        @apply_config_args_one_arg_same_value_unlocked, ...
        @apply_config_args_one_arg_same_value_locked, ...
        @apply_config_args_fail_wrong_arg_name, ...
        @apply_config_args_fail_wrong_arg_value, ...
        @check_alias_stru_empty_1, ...
        @check_alias_stru_empty_2, ...
        @check_alias_stru_alias, ...
        @check_alias_stru_fail_wrong_command_name, ...
        @check_alias_stru_fail_empty_command_stru_1, ...
        @check_alias_stru_fail_empty_command_stru_2, ...
        @check_command_args_fail_wrong_commmand_name, ...
        @check_command_args_fail_wrong_arg_type, ...
        @check_command_args_fail_wrong_arg_count, ...
        @check_command_args_ok, ...
        @check_command_stru_and_default_octave_fail_builtin, ...
        @check_command_stru_and_default_matlab_success_builtin, ...
        @check_command_stru_and_default_fail_wrong_default_arg_type, ...
        @check_command_stru_and_default_fail_wrong_default_value, ...
        @check_command_stru_and_default_fail_wrong_stru_type, ...
        @check_command_stru_and_default_fail_empty_stru_1, ...
        @check_command_stru_and_default_fail_empty_stru_2, ...
        @check_command_stru_and_default_fail_no_stru, ...
        @check_command_stru_and_default_fail_wrong_no_return_value, ...
        @check_command_stru_and_default_fail_wrong_valid, ...
        @check_command_stru_and_default_fail_missing_no_return_value, ...
        @check_command_stru_and_default_fail_missing_valid, ...
        @check_command_stru_and_default_ok, ...
        @command_alias_expansion_no_arg, ...
        @command_alias_expansion_fail_wrong_first_arg, ...
        @command_alias_expansion_cmd, ...
        @command_alias_expansion_alias_no_arg, ...
        @command_alias_expansion_alias_arg, ...
        @command_and_config_args_fixed_cmd_args_no_cf_arg, ...
        @command_and_config_args_fixed_cmd_args_one_cf_arg, ...
        @command_and_config_args_var_cmd_args_no_cf_arg, ...
        @command_and_config_args_var_cmd_args_no_cf_arg_2, ...
        @command_and_config_args_var_cmd_args_one_cf_arg, ...
        @default_config_empty_s, ...
        @default_config_non_scalar_empty_struct, ...
        @default_config_fail_wrong_s_type, ...
        @default_config_fail_no_s_default, ...
        @default_config_fail_no_s_valid, ...
        @default_config_fail_wrong_s_valid, ...
        @default_config_fail_wrong_default, ...
        @default_config_no_app_name, ...
        @default_config_app_name, ...
        @default_config_appdata, ...
        @find_string_first_occurrence_in_cell_array_empty, ...
        @find_string_first_occurrence_in_cell_array_zero, ...
        @find_string_first_occurrence_in_cell_array_non_zero, ...
        @no_appdata_end, ...
        @strip_defaults_from_config_stru_fail_wrong_cf_type, ...
        @strip_defaults_from_config_stru_fail_wrong_ori_type, ...
        @strip_defaults_from_config_stru_fail_wrong_ori_field_type, ...
        @strip_defaults_from_config_stru_fail_missing_ori_field, ...
        @strip_defaults_from_config_stru_ok};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function s = cmdstrubuiltin

    s = struct('cmd1', struct('valid', @islogical, 'no_return_value', false));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function s = cmdstru

    s = struct(...
        'cmd1', ...
        struct('valid', @(x) islogical(x), 'no_return_value', false), ...
        'cmd2', ...
        struct('valid', @(x) isnumeric(x), 'no_return_value', false));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function s = cmdstru2

    s = struct(...
        'cmd1', struct(...
            'valid', @(x) islogical(x), 'no_return_value', false), ...
        'cmd2', struct(...
            'valid', @(x) isnumeric(x), 'no_return_value', false), ...
        'cmd3', struct(...
            'valid', @(varargin) nargin, 'no_return_value', false));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function [dflt, cf, ori] = cfstrus

    dflt = struct(...
        'arg1logic', ...
        struct('default', false, 'valid', @islogical), ...
        'arg2num', ...
        struct('default', 1, 'valid', @isnumeric));
    cf = struct('arg1logic', false, 'arg2num', 2);
    ori = struct('arg1logic', 'Default', ...
        'arg2num', ['Session specific configuration ' ...
            '(getappdata(0, ''test''))']);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function s = aliasstru

    s = struct('alias1', {{'cmd1'}});
    s.alias2 = {'cmd2', 1};

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function str = appname

    str = mfilename;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = no_appdata_begin

    ret = isempty(getappdata(0, appname));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = no_appdata_end

    ret = no_appdata_begin;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function apply_config_args_fail_invalid_appname

    apply_config_args(true, false);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function apply_config_args_fail_invalid_locked

    apply_config_args('test', 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = apply_config_args_empty_1

    [cf, ori] = apply_config_args('test', struct(), struct(), struct(), false);
    ret = isequal(cf, struct()) && isequal(ori, struct());

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = apply_config_args_empty_2

    [cf, ori] = apply_config_args(...
        'test', struct([]), struct([]), struct([]), false);
    ret = isequal(cf, struct([])) && isequal(ori, struct([]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = apply_config_args_no_arg

    [dflt, cf1, ori1] = cfstrus;
    [cf, ori] = apply_config_args('test', dflt, cf1, ori1, false);
    ret = isequal(cf, cf1) && isequal(ori, ori1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = apply_config_args_two_args

    [dflt, cf1, ori1] = cfstrus;
    arg2numArgValue = cf1.arg2num + 1;
    [cf, ori] = apply_config_args('test', dflt, cf1, ori1, false, ...
        'arg2num', arg2numArgValue, 'arg1logic', cf1.arg1logic);
    expectedCf = cf1;
    expectedCf.arg2num = arg2numArgValue;
    expectedOri = ori1;
    expectedOri.arg1logic = ['Default (configuration argument with same ' ...
        'value has been ignored)'];
    expectedOri.arg2num = 'Configuration argument on first call to test';
    ret = isequal(cf, expectedCf) && isequal(ori, expectedOri);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = apply_config_args_one_arg_same_value_unlocked

    [dflt, cf1, ori1] = cfstrus;
    [cf, ori] = apply_config_args('test', dflt, cf1, ori1, false, ...
        'arg1logic', cf1.arg1logic);
    expectedOri = ori1;
    expectedOri.arg1logic = ['Default (configuration argument with same ' ...
        'value has been ignored)'];
    ret = isequal(cf, cf1) && isequal(ori, expectedOri);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = apply_config_args_one_arg_same_value_locked

    [dflt, cf1, ori1] = cfstrus;
    [cf, ori] = apply_config_args('test', dflt, cf1, ori1, true, ...
        'arg1logic', cf1.arg1logic);
    ret = isequal(cf, cf1) && isequal(ori, ori1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function apply_config_args_fail_wrong_arg_name

    [dflt, cf1, ori1] = cfstrus;
    apply_config_args('test', dflt, cf1, ori1, false, 'wrong_arg_name', ...
        cf1.arg1logic);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function apply_config_args_fail_wrong_arg_value

    [dflt, cf1, ori1] = cfstrus;
    apply_config_args('test', dflt, cf1, ori1, false, 'arg2num', ...
        cf1.arg1logic);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = check_alias_stru_empty_1

    check_alias_stru(cmdstru, struct());
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = check_alias_stru_empty_2

    check_alias_stru(cmdstru, struct([]));
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = check_alias_stru_alias

    check_alias_stru(cmdstru, aliasstru);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_alias_stru_fail_wrong_command_name

    s = struct('alias1', {{'cmd11'}});
    check_alias_stru(cmdstru, s);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_alias_stru_fail_empty_command_stru_1

    s = struct('alias1', {{'cmd1'}});
    check_alias_stru(struct(), s);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_alias_stru_fail_empty_command_stru_2

    s = struct('alias1', {{'cmd1'}});
    check_alias_stru(struct([]), s);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_args_fail_wrong_commmand_name

    check_command_args(cmdstru, 'wrong_cmd_name');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_args_fail_wrong_arg_type

    check_command_args(cmdstru, 'cmd1', 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_args_fail_wrong_arg_count

    check_command_args(cmdstru, 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = check_command_args_ok

    check_command_args(cmdstru, 'cmd1', true);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_octave_fail_builtin

    if is_octave
        check_command_stru_and_default(cmdstrubuiltin, 'cmd1');
    else
        error('Error statement');
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = check_command_stru_and_default_matlab_success_builtin

    ret = true;
    if ~is_octave
        check_command_stru_and_default(cmdstrubuiltin, 'cmd1');
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_wrong_default_arg_type

    check_command_stru_and_default(cmdstru, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_wrong_default_value

    check_command_stru_and_default(cmdstru, 'wrong_command_name');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_wrong_stru_type

    check_command_stru_and_default(0, 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_empty_stru_1

    check_command_stru_and_default(struct(), 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_empty_stru_2

    check_command_stru_and_default(struct([]), 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_no_stru

    check_command_stru_and_default(struct('cmd1', 0), 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_wrong_no_return_value

    check_command_stru_and_default(struct('cmd1', ...
        struct('valid', @(x) islogical(x), 'no_return_value', 0)), 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_wrong_valid

    check_command_stru_and_default(struct('cmd1', ...
        struct('valid', 0, 'no_return_value', true)), 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_missing_no_return_value

    check_command_stru_and_default(struct('cmd1', ...
        struct('valid', @(x) islogical(x))), 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function check_command_stru_and_default_fail_missing_valid

    check_command_stru_and_default(struct('cmd1', ...
        struct('no_return_value', true)), 'cmd1');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = check_command_stru_and_default_ok

    check_command_stru_and_default(cmdstru, 'cmd1');
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_alias_expansion_no_arg

    s = cmdstru;
    c = fieldnames(s);
    dfltCmd = c{1};
    ret = isequal({dfltCmd}, ...
        command_alias_expansion(dfltCmd, aliasstru));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function command_alias_expansion_fail_wrong_first_arg

    s = cmdstru;
    c = fieldnames(s);
    dfltCmd = c{1};
    command_alias_expansion(dfltCmd, aliasstru, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_alias_expansion_cmd

    s = cmdstru;
    c = fieldnames(s);
    dfltCmd = c{1};
    cmd = 'cmd2';
    arg = 0;
    ret = isequal({cmd, arg}, ...
        command_alias_expansion(dfltCmd, aliasstru, cmd, arg));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_alias_expansion_alias_no_arg

    s = cmdstru;
    c = fieldnames(s);
    dfltCmd = c{1};
    as = aliasstru;
    cmd = 'alias1';
    arg = true;
    ret = isequal([as.(cmd), {arg}], ...
        command_alias_expansion(dfltCmd, as, cmd, arg));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_alias_expansion_alias_arg

    s = cmdstru;
    c = fieldnames(s);
    dfltCmd = c{1};
    as = aliasstru;
    cmd = 'alias2';
    ret = isequal(as.(cmd), ...
        command_alias_expansion(dfltCmd, as, cmd));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_and_config_args_fixed_cmd_args_no_cf_arg

    s = cmdstru;
    c = fieldnames(s);
    dfltCmd = c{1};
    a = {dfltCmd, true};
    [cmd, cmdA, cfA] = command_and_config_args(a, s);
    ret = isequal(cmd, a{1}) && isequal(cmdA, a(2)) && isequal(cfA, {});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_and_config_args_fixed_cmd_args_one_cf_arg

    s = cmdstru;
    c = fieldnames(s);
    dfltCmd = c{1};
    a = {dfltCmd, true, 'cfparam', 1};
    [cmd, cmdA, cfA] = command_and_config_args(a, s);
    ret = isequal(cmd, a{1}) && isequal(cmdA, a(2)) ...
        && isequal(cfA, a(3 : end));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_and_config_args_var_cmd_args_no_cf_arg

    s = cmdstru2;
    dfltCmd = 'cmd3';
    a = {dfltCmd, true};
    [cmd, cmdA, cfA] = command_and_config_args(a, s);
    ret = isequal(cmd, a{1}) && isequal(cmdA, a(2 : end)) && isequal(cfA, {});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_and_config_args_var_cmd_args_no_cf_arg_2

    s = cmdstru2;
    dfltCmd = 'cmd3';
    a = {dfltCmd, true, 'cfparam', 1};
    [cmd, cmdA, cfA] = command_and_config_args(a, s);
    ret = isequal(cmd, a{1}) && isequal(cmdA, a(2 : end)) && isequal(cfA, {});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = command_and_config_args_var_cmd_args_one_cf_arg

    s = cmdstru2;
    dfltCmd = 'cmd3';
    a = {dfltCmd, true, '--', 'cfparam', 1};
    [cmd, cmdA, cfA] = command_and_config_args(a, s);
    ret = isequal(cmd, a{1}) && isequal(cmdA, a(2)) ...
        && isequal(cfA, a(4 : end));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = default_config_empty_s

    [cf, ori] = default_config(struct());
    ret = isequal(cf, struct()) && isequal(ori, struct());

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function default_config_non_scalar_empty_struct

    default_config(struct([]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function default_config_fail_wrong_s_type

    default_config(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function default_config_fail_no_s_default

    default_config(struct('cfparam', ...
        struct('d', true, 'valid', @islogical)));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function default_config_fail_no_s_valid

    default_config(struct('cfparam', ...
        struct('default', true, 'v', @islogical)));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function default_config_fail_wrong_s_valid

    default_config(struct('cfparam', ...
        struct('default', true, 'valid', 'abc')));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function default_config_fail_wrong_default

    default_config(struct('cfparam', ...
        struct('default', 0, 'valid', @islogical)));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = default_config_no_app_name

    [cf, ori] = default_config(struct(...
        'cfparam1', struct('default', true, 'valid', @islogical), ...
        'cfparam2', struct('default', 0, 'valid', @isnumeric)));
    ret = isequal(cf, struct('cfparam1', true, 'cfparam2', 0)) ...
        && isequal(ori, struct('cfparam1', 'Default', 'cfparam2', 'Default'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = default_config_app_name

    [cf, ori] = default_config(struct(...
        'cfparam1', struct('default', true, 'valid', @islogical), ...
        'cfparam2', struct('default', 0, 'valid', @isnumeric)), ...
        appname);
    ret = isequal(cf, struct('cfparam1', true, 'cfparam2', 0)) ...
        && isequal(ori, struct('cfparam1', 'Default', 'cfparam2', 'Default'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = default_config_appdata

    ret = false;
    if no_appdata_begin
        setappdata(0, appname, struct('cfparam2', 2));
        [cf, ori] = default_config(struct(...
            'cfparam1', struct('default', true, 'valid', @islogical), ...
            'cfparam2', struct('default', 0, 'valid', @isnumeric)), ...
            appname);
        ret = isequal(cf, struct('cfparam1', true, 'cfparam2', 2)) ...
            && isequal(ori, ...
            struct('cfparam1', 'Default', 'cfparam2', ['Session specific ' ...
            'configuration (getappdata(0, ''test_appmech''))']));
        rmappdata(0, appname);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = find_string_first_occurrence_in_cell_array_empty

    ret = find_string_first_occurrence_in_cell_array('abc', {}) == 0;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = find_string_first_occurrence_in_cell_array_zero

    ret = find_string_first_occurrence_in_cell_array('abc', {true, 'ab'}) == 0;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = find_string_first_occurrence_in_cell_array_non_zero

    ret = find_string_first_occurrence_in_cell_array('abc', ...
        {true, 'abc', 1, 'abc'}) == 2;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_defaults_from_config_stru_fail_wrong_cf_type

    strip_defaults_from_config_stru(true, ...
        struct('field1', 'Default', 'field2', 'Default'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_defaults_from_config_stru_fail_wrong_ori_type

    strip_defaults_from_config_stru(struct('field1', 0, 'field2', 1), true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_defaults_from_config_stru_fail_wrong_ori_field_type

    [~, cf, ori] = cfstrus;
    ori.arg1logic = true;
    strip_defaults_from_config_stru(cf, ori);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function strip_defaults_from_config_stru_fail_missing_ori_field

    [~, cf, ori] = cfstrus;
    ori = rmfield(ori, 'arg1logic');
    strip_defaults_from_config_stru(cf, ori);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = strip_defaults_from_config_stru_ok

    [~, cf, ori] = cfstrus;
    ret = isequal(rmfield(cf, 'arg2num'), ...
        strip_defaults_from_config_stru(cf, ori));

endfunction

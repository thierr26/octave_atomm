## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} test_argcheck ()
##
## Test the argcheck toolbox.
##
## @code{test_argcheck} tests the argcheck toolbox and returns a structure.
## This structure is a structure returned by @code{run_test_case} and can be
## used as argument to @code{report_test_rslt}.
##
## @seealso{report_test_rslt, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_argcheck

    # Declare the test routines.
    testRoutine = {...
        @validated_mandatory_args_fail_invalid_f, ...
        @validated_mandatory_args_fail_shape, ...
        @validated_mandatory_args_empty, ...
        @validated_mandatory_args_1, ...
        @validated_mandatory_args_2, ...
        @validated_mandatory_args_fail_wrong, ...
        @validated_opt_args_fail_empty, ...
        @validated_opt_args_fail_dim, ...
        @validated_opt_args_fail_shape, ...
        @validated_opt_args_fail_invalid_f, ...
        @validated_opt_args_fail_invalid_dflt_v, ...
        @validated_opt_args_fail_too_many, ...
        @validated_opt_args_1_0, ...
        @validated_opt_args_1_1, ...
        @validated_opt_args_2_0, ...
        @validated_opt_args_2_1, ...
        @validated_opt_args_2_2};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function validated_mandatory_args_fail_invalid_f

    validated_mandatory_args(1);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function validated_mandatory_args_fail_shape

    validated_mandatory_args({@iscell; @isstruct}, {}, struct());

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = validated_mandatory_args_empty

    validated_mandatory_args({});
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = validated_mandatory_args_1

    expected = {};
    ret = isequal(expected, validated_mandatory_args({@iscell}, {}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = validated_mandatory_args_2

    [c, s] = validated_mandatory_args({@iscell, @isstruct}, {}, struct());
    ret = isequal(c, {}) && isequal(s, struct());

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function validated_mandatory_args_fail_wrong

    validated_mandatory_args({@iscell}, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function validated_opt_args_fail_empty

    validated_opt_args({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function validated_opt_args_fail_dim

    validated_opt_args(zeros(1, 1, 2));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function validated_opt_args_fail_shape

    validated_opt_args({@iscell, 0, 0});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function validated_opt_args_fail_invalid_f

    validated_opt_args({0, 0});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function validated_opt_args_fail_invalid_dflt_v

    validated_opt_args({@iscell, 0});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function validated_opt_args_fail_too_many

    validated_opt_args({@iscell, {}}, {}, {});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = validated_opt_args_1_0

    expected = {};
    ret = isequal(expected, validated_opt_args({@iscell, {}}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = validated_opt_args_1_1

    expected = {0};
    ret = isequal(expected, validated_opt_args({@iscell, {}}, {0}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = validated_opt_args_2_0

    [c, s] = validated_opt_args({@iscell, {}; @isstruct, struct([])});
    ret = isequal(c, {}) && isequal(s, struct([]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = validated_opt_args_2_1

    [c, s] = validated_opt_args({@iscell, {}; @isstruct, struct([])}, {0});
    ret = isequal(c, {0}) && isequal(s, struct([]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = validated_opt_args_2_2

    [c, s] = validated_opt_args({@iscell, {}; @isstruct, struct([])}, ...
        {0}, struct('field', 1));
    ret = isequal(c, {0}) && isequal(s, struct('field', 1));

endfunction

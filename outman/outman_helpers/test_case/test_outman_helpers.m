## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_outman_helpers ()
##
## Run test case for toolbox "lib_outman", return results as a structure.
##
## @code{@var{s} = test_outman_helpers ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_outman_helpers" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "lib_outman".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_outman_helpers

    # Declare the test routines.
    testRoutine = {...
        @outman_c_fail_wrong_condition_type, ...
        @outman_c_fail_wrong_command_type, ...
        @outman_c_fail_wrong_caller_id_type, ...
        @outman_c_fail_wrong_command, ...
        @outman_c_fail_command_ok, ...
        @outman_c_fail_alias_ok, ...
        @outman_connect_and_config_if_master_c_fail_wrong_condition_type, ...
        @outman_connect_and_config_false, ...
        @outman_connect_and_config_true};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function outman_c_fail_wrong_condition_type

    outmanErr = false;
    try
        oId = outman_connect_and_config_if_master;
    catch
        outmanErr = true;
    end_try_catch

    if ~outmanErr
        try
            outman_c(struct(), 'cancel_progress', oId, -1);
        catch err
            outman('disconnect', oId);
            rethrow(err);
        end_try_catch

        try
            outman('disconnect', oId);
        catch
            1;
        end_try_catch
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function outman_c_fail_wrong_command_type

    outmanErr = false;
    try
        oId = outman_connect_and_config_if_master;
    catch
        outmanErr = true;
    end_try_catch

    if ~outmanErr
        try
            outman_c(true, struct(), oId, -1);
        catch err
            outman('disconnect', oId);
            rethrow(err);
        end_try_catch

        try
            outman('disconnect', oId);
        catch
            1;
        end_try_catch
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function outman_c_fail_wrong_caller_id_type

    outmanErr = false;
    try
        oId = outman_connect_and_config_if_master;
    catch
        outmanErr = true;
    end_try_catch

    if ~outmanErr
        try
            outman_c(true, 'cancel_progress', struct(), -1);
        catch err
            outman('disconnect', oId);
            rethrow(err);
        end_try_catch

        try
            outman('disconnect', oId);
        catch
            1;
        end_try_catch
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function outman_c_fail_wrong_command

    outmanErr = false;
    try
        oId = outman_connect_and_config_if_master;
    catch
        outmanErr = true;
    end_try_catch

    if ~outmanErr
        try
            outman_c(true, 'terminate_progress', struct(), -1);
        catch err
            outman('disconnect', oId);
            rethrow(err);
        end_try_catch

        try
            outman('disconnect', oId);
        catch
            1;
        end_try_catch
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_c_fail_command_ok

    oId = outman_connect_and_config_if_master;
    try
        outman_c(true, 'cancel_progress', oId, -1);
    catch err
        outman('disconnect', oId);
        rethrow(err)
    end_try_catch
    outman('disconnect', oId);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_c_fail_alias_ok

    oId = outman_connect_and_config_if_master;
    try
        outman_c(true, 'q', oId);
    catch err
        outman('disconnect', oId);
        rethrow(err)
    end_try_catch
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function outman_connect_and_config_if_master_c_fail_wrong_condition_type

    outman_connect_and_config_if_master_c(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_connect_and_config_false

    oId = outman_connect_and_config_if_master_c(false);
    ret = oId == -1;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = outman_connect_and_config_true

    oId = outman_connect_and_config_if_master_c(true);
    outman('disconnect', oId);
    ret = oId >= 0;

endfunction

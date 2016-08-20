## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} toolman ()
## @deftypefnx {Function File} toolman ('list_declared_deps')
## @deftypefnx {Function File} toolman ('list_declared_deps', @var{@
## toolbox_designation})
## @deftypefnx {Function File} toolman ('list_declared_deps', @var{m_file})
## @deftypefnx {Function File} toolman ('add_to_path')
## @deftypefnx {Function File} toolman ('add_to_path', @var{@
## toolbox_designation})
## @deftypefnx {Function File} toolman ('add_to_path', @var{m_file})
## @deftypefnx {Function File} toolman ('run_test')
## @deftypefnx {Function File} toolman ('run_test', @var{toolbox_designation})
## @deftypefnx {Function File} toolman ('run_test', @var{m_file})
## @deftypefnx {Function File} toolman ('get_config')
## @deftypefnx {Function File} toolman ('get_config_origin')
## @deftypefnx {Function File} toolman (..., '--', @var{@
## config_param_1_name}, @var{config_param_1_value}, @var{@
## config_param_2_name}, @var{config_param_2_value}, ...)
## @deftypefnx {Function File} toolman (..., '--', @var{s})
## @deftypefnx {Function File} toolman ('quit')
##
## Add toolboxes to path and run tests.
##
## @code{toolman ()} starts up Toolman and configures it with the default
## configuration parameters.  Please read below for more details about
## Toolman's configuration parameters.  Note that it is not mandatory to issue
## such an argument free call to start up Toolman.  You can startup Toolman
## and invoke directly a command.  The command name must be provided as the
## first argument.
##
## The supported commands are:
##
## @table @asis
## @item "list_declared_deps"
## List the dependencies for a toolbox, based on the dependencies declared in
## the "dependencies" or "dependencies.txt" files.  The toolbox is the current
## directory if no other argument is provided, or the toolbox designated with
## @var{toolbox_designation}, or the toolbox containing M-file @var{m_file}.  A
## cell array of strings containing the absolute path of the toolbox and its
## dependencies is returned.
##
## @var{toolbox_designation} is a toolbox directory base name.  One or more
## parent directory names can be prepended (with a "/" or "\" separator) if it
## is needed to disambigate the toolbox designation.
##
## @var{m_file} is the base name of an M-file with or without the extension
## (examples: "myfunction.m", "myfunction").  An error is issued if multiple
## M-files with name @var{m_file} exist in the M-file tree(s).  The top(s) of
## the M-file tree(s) are defined via the "top" configuration parameter
## mentionned farther in this documentation.
##
## @item "add_to_path"
## Do the same as when invoked with command "list_declared_deps", except that
## the toolbox and its dependencies is actually added to the path.  The listing
## is not output to the command window if there is an output argument.  It is
## always written to the log file (if any).
##
## @item "run_test"
## Do the same as when invoked with command "add_to_path", except that the test
## case toolboxes for the toolbox and its dependencies are added to the path
## and the test cases run.  No report is output to the command window if there
## is an output argument, otherwise the report generated by
## @code{report_test_rslt} is output to the command window.  The report is
## always written to the log file (if any).
##
## @item "get_config"
## Get Toolman's whole configuration structure (a structure where each field
## name is a configuration parameter name for Toolman and the associated field
## values are the configuration parameter values).
##
## @item "get_config_origin"
## Get Toolman's configuration origin structure (a structure where each field
## name is a configuration parameter name for Toolman and the associated
## field values are strings indicating where the configuration parameter values
## come from).
## @end table
##
## Toolman uses Outman for its output.  Outman's configuration parameters can
## be provided via Toolman's command line after a "--" argument.  They can be
## provided as "name-value pairs" or as a structure @var{s}.  Please see the
## documentation for @code{outman_connect_and_config_if_master} for more
## details about Outman's configuration parameters.
##
## Toolman has three configuration parameters.  One is named "top" and is the
## path to the top of the M-file tree.  If your toolboxes are spread in
## multiple trees, you can set "top" as a cell array of strings containing the
## path to the top directories of all the trees.  The "top" configuration
## parameters defaults to the current directory.
##
## The other configuration parameters are regular expressions that the test
## case toolboxes and the test case M-files are supposed to match.  They are
## named "test_case_tb_reg_exp" and "test_case_reg_exp" respectively.  They
## both default to "^test_".  The test case toolbox for a given toolbox must be
## a subdirectory of this toolbox.
##
## To set the configuration parameters to specific (non default) values,
## provide them on the Toolman's command line after the "--" argument along
## with the Outman's configuration parameters.
##
## Note that you can also alter the default configuration parameter values by
## assigning first a structure using a
## @code{setappdata(0, 'toolman', @var{s})} instruction.
##
## Once Toolman has been configured, a @code{toolman ('quit')} command must
## be issued to be able to reconfigure it.
##
## @seealso{checkmtree, outman, report_test_rslt}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = toolman(varargin)

    persistent name dConf cfLocked config configOrigin cmd cmdDflt alias state;

    if isempty(cfLocked)

        name = app_name;
        # app_name is an application specific private function.

        [cmd, cmdDflt] = command_stru_and_default;
        # command_stru_and_default is an application specific private function.

        check_command_stru_and_default(cmd, cmdDflt);

        alias = alias_stru;
        # alias_stru is an application specific private function.

        check_alias_stru(cmd, alias);

        dConf = config_stru;
        # config_stru is an application specific private function.

        [config, configOrigin] = default_config(dConf, name);

        cfLocked = false;

        state = struct();
    endif

    try
        # Perform user argument checking, which may throw an error.

        arg = command_alias_expansion(cmdDflt, alias, varargin{:});
        check_command_name(cmd, arg{:});
        [cmdName, cmdArg, configArgs] = command_and_config_args(arg, cmd);
        [config, configOrigin] = apply_config_args(...
            name, dConf, config, configOrigin, cfLocked, configArgs{:});
        check_command_args(cmd, cmdName, cmdArg{:});
    catch e
        if ~cfLocked
            # Reset application persistent variables, which will allow the next
            # configuration attempt to be successful.
            clear(mfilename);
        endif
        rethrow(e);
    end_try_catch

    cfLocked = true;

    if cmd.(cmdName).no_return_value
        minCmdOutputArgCount = 0;
    else
        minCmdOutputArgCount = 1;
    endif
    CmdOutputArgCount = max([minCmdOutputArgCount nargout]);
    [clearAppRequested, state, varargout{1 : CmdOutputArgCount}] ...
        = run_command(cmdName, cmdArg, config, configOrigin, state, ...
            nargout, name);

    if clearAppRequested
        munlock;
        clear(mfilename);
    else
        mlock;
    endif

endfunction
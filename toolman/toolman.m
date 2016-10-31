## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} toolman ('add_to_path', ...)
## @deftypefnx {Function File} {@var{@
## added_to_path} =} toolman ('add_to_path', ...)
## @deftypefnx {Function File} {[~] =} toolman ('add_to_path', ...)
## @deftypefnx {Function File} toolman ('refresh_cache')
## @deftypefnx {Function File} {@var{@
## list} =} toolman ('list_declared_deps', ...)
## @deftypefnx {Function File} toolman ('run_test', ...)
## @deftypefnx {Function File} {@var{@
## added_to_path} =} toolman ('run_test', ...)
## @deftypefnx {Function File} {[~] =} toolman ('run_test', ...)
## @deftypefnx {Function File} {@var{config} =} toolman ('configure', @var{@
## config_param_1_name}, @var{config_param_1_value}, @var{@
## config_param_2_name}, @var{config_param_2_value}, ...)
## @deftypefnx {Function File} {@var{config} =} toolman ('configure', @var{@
## config_params_as_a_structure})
## @deftypefnx {Function File} {@var{config} =} toolman ('get_config')
## @deftypefnx {Function File} {@var{@
## config_origin} =} toolman ('get_config_origin')
## @deftypefnx {Function File} toolman ('quit')
##
## Add toolboxes to path, run test cases.
##
## @strong{Adding to the function search path is Toolman's primary job.}
##
## The primary functionality of Toolman is to add some directories (also called
## toolboxes) to the function search path so that the user defined functions
## (i.e.@ not built-in or standard Octave / Matlab functions) from a particular
## toolbox are available and usable without getting an "undefined function"
## error.
##
## Let's take an example.  In the Atomm source tree, there is a toolbox called
## "env".  In this toolbox, there are Octave function files (M-files).  One of
## these is home_dir.m.  This file defines the function @code{home_dir}.  If
## you read the content of the file (the code of function @code{home_dir}), you
## see that @code{home_dir} issues calls to other functions: @code{isempty},
## @code{ispc}, @code{absolute_path}, etc.
##
## @code{isempty} is an Octave / Matlab built-in function and is always
## available (i.e.@ you can call it any time without getting an "undefined
## function" error).  @code{ispc} is a standard Octave / Matlab function and is
## always available because the directory that contains the file that defines
## @code{ispc} is by default in the Octave / Matlab function search path
## (unless perhaps your Octave / Matlab configuration is untypical).
## @code{absolute_path} is neither a built-in function nor a standard function,
## but a user-defined function.  It is not available as long as the toolbox
## containing the file that defines @code{absolute_path} (the toolbox called
## "fsys" in the Atomm source tree) is not in the function search path.  But
## adding the "fsys" toolbox to the function search path is probably not
## sufficient.  If function @code{absolute_path} calls other user defined
## functions, then these functions must also be available and this probably
## implies adding more toolboxes to the function search path.
##
## Octave and Matlab provide functions@footnote{Octave and Matlab provide
## function @code{addpath} to add one or multiple toolboxes to the function
## search path.  Example:
##
## @example
## @group
## addpath ('path/to/atomm/fsys');
## @end group
## @end example
##
## Octave and Matlab also provide function @code{genpath} that can be used with
## @code{addpath} to add a full source tree to the function search path with
## only one statement.  It is very useful when the functions that are needed in
## the function search path are located in various subdirectories of a source
## tree.  For example, a statement like the following one adds the atomm
## directory and its subdirectories to the function search path (except the
## directories called "private" which don't have to be in the function search
## path).
##
## @example
## @group
## addpath (genpath ('path/to/atomm'));
## @end group
## @end example
##
## Such a statement may have the disadvantage of adding more directories to the
## function search path than is really needed.  For example:
##
## @itemize @bullet
## @item
## Directories that contain only unneeded function files.
##
## @item
## Directories that don't contain any function files.
##
## @item
## Hidden directories  (like ".git", ".svn", etc.) created by version control
## software systems.  There is no point adding such directories to the function
## search path.
## @end itemize
## } to add toolboxes to the function search path but none to add easily all
## the needed toolboxes and not more.  Toolman provides a way to achieve that
## as long as "dependency files" are present and kept up to date in your source
## trees.
##
## @strong{Toolman relies on dependency files.}
##
## A dependency file is a text file named "dependencies" or "dependencies.txt".
## There is such a file in the "env" toolbox of the Atomm source tree.  If you
## read this file, you see a line saying "atomm/fsys".  This means that the
## functions defined in the "env" toolbox are not available if the functions
## defined in the "fsys" toolbox are not themselves available.  In other words,
## the dependency file declares that the "fsys" toolbox is a dependency for
## the "env" toolbox.  The "fsys" directory also contains a dependency file
## which declares that some toolboxes are dependencies for "fsys", and so on.
##
## The dependency files allow Toolman to find recursively all the toolboxes
## that must be in the function search path to make the functions from a
## particular toolbox available and usable without error.  Of course, Toolman
## must "know" where to find the dependency files.  The user can provide the
## list of the source trees (more precisely the list of the top directories of
## these source trees) to Toolman via a configuration parameter called
## @qcode{"top"}.  More details about Toolman's configuration parameters later
## in this documentation.
##
## Here are the rules that must be obeyed when writing dependency files.  Note
## that toolboxes that don't depend on any other toolbox don't need any
## dependency file (but they can have an empty one or one containing only
## comments).  Not also that Checkmtree is provided in the Atomm source tree
## to help writing and maintaining the dependency files.  Checkmtree can
## detect missing and superfluous dependency declarations as well as badly
## written dependency files.  Please run @code{help checkmtree} for more
## information about Checkmtree.
##
## @enumerate
## @item
## A dependency file must not mention its own toolbox.  Toolman "instinctively
## knows" that for example the "env" toolbox must be in the function search
## path if you want to use the functions defined in "env".
##
## @item
## There must be no dependency file in a "private" directory.  If the functions
## defined in a "private" directory (which are private functions) call user
## defined functions from other directories, then the dependency file
## of the parent directory must declare the dependencies.
##
## @item
## There must be zero or one dependency file in a toolbox  There must not be a
## dependency file named "dependencies" and another one named
## "dependencies.txt" in the same toolbox.
##
## @item
## If you want to put comments in a dependency file, use Octave or Matlab style
## comments (both end of line comments and block comments are supported).
##
## @item
## Declare a dependency by writing the path to the toolbox on a line of the
## dependency file.  The path can be absolute or relative and if it is
## relative, you are free to choose to which directory it is relative (see
## below for hints on how to choose).
##
## @item
## Do not declare more than one dependency on a line of a dependency file.
## @end enumerate
##
## Using absolute paths for dependency declarations should generally be avoided
## because it is very unlikely that every user of this dependency places it at
## exactly the same path.
##
## Using relative path for dependency declarations is recommended instead.
## However, the writer of a dependency file must carefully choose to which
## directory its dependency declarations are relative.  In our example, the
## dependency file in the "env" toolbox of the Atomm source tree declares the
## dependency to the "fsys" toolbox as "atomm/fsys".  It could have declared it
## as "fsys" instead, but this would have been risky because it is quite
## possible that a user of Atomm also uses other collections of Octave / Matlab
## functions containing an "fsys" toolbox.  In this case, the declaration would
## be ambiguous for Toolman.  "atomm/fsys" is much less likely to be ambiguous.
##
## @strong{Running test cases recursively is Toolman's other job.}
##
## The secondary functionality of Toolman is to run the test cases for a
## toolbox and its dependencies.  Of course, Toolman relies on the dependency
## files for that.  It also relies on the facts that the test cases are
## functions that fulfill all the following conditions:
##
## @itemize @bullet
## @item
## They're callable without any input argument.
##
## @item
## They return the kind of structures that function @code{run_test_case}
## returns.  Please run @code{help run_test_case} for all the details about
## that kind of structures.
##
## @item
## They're located in subdirectories of the toolboxes they are testing.  The
## name of these subdirectories match a regular expression.  For every toolbox,
## there must be at most one subdirectory matching the regular expression.  By
## default, this regular expression is "^test_".  This means that the names of
## the subdirectories start with "test_".  You can instruct Toolman to use
## another regular expression via a configuration parameter called
## @qcode{"test_case_tb_reg_exp"}.  More details about Toolman's configuration
## parameters later in this documentation.
##
## @item
## Their names (i.e.@ the name of the functions) match a regular expression.
## For every toolbox, there can be multiple functions matching the regular
## expression.  By default, this regular expression is "^test_".  This means
## that the names of the test case functions start with "test_".  You can
## instruct Toolman to use another regular expression instead via a
## configuration parameter called @qcode{"test_case_reg_exp"}.  More details
## about Toolman's configuration parameters later in this documentation.
## @end itemize
##
## There are multiple examples of test cases in the Atomm source tree.  For
## example the test case for toolbox "structure" is function
## @code{test_structure}.  It is located in the structure/test_case
## subdirectory.
##
## Let's see now how to use Toolman.  First, let's assume that Atomm is the
## only collection of user defined functions that you use AND that the atomm
## directory is your current working directory (use function @code{pwd} to
## check what your current working directory is and function @code{cd} to
## change the current working directory if needed).
##
## @strong{A script is provided to enable Toolman (i.e.@ add it to the path).}
##
## The first thing to do is to add the Toolman toolbox and its dependencies to
## the function search path.  At this stage, you can't use Toolman for such a
## task because Toolman is still not available, but a script that will do the
## job is provided in the Atomm source tree.  It is called "enable_toolman" and
## is located in the toolman/enable_toolman directory.  You can run it using
## function @code{run} (adjust the path to the Atomm source tree):
##
## @example
## @group
## run ('path/to/atomm/toolman/enable_toolman/enable_toolman.m');
## @end group
## @end example
##
## Of course, you can add this command to a startup file so that you don't have
## to type it every time you launch Octave or Matlab.
##
## @strong{Add toolboxes to path with Toolman's command @qcode{"add_to_path"}.}
##
## Let's say now that you want to run @code{demo_outman} (a function that
## serves as a demonstration program for Outman and is provided in the Atomm
## source tree).  Have Toolman add it and its dependencies to the function
## search path using Toolman's command @qcode{"add_to_path"} and run it.
##
## @example
## @group
## toolman ('add_to_path', 'demo_outman');
## demo_outman;
## @end group
## @end example
##
## The @code{toolman ('add_to_path', 'demo_outman');} statement has caused
## Toolman to explore the source tree, read the dependency files, compute the
## list of toolboxes that had to be added to the function search path to make
## @code{demo_outman} available and add these toolboxes to the function search
## path.
##
## Note that the source tree exploration and dependency files reading stages
## are executed only once after Toolman starts.  Toolman caches the resulting
## information to speed up the execution of subsequent commands.  You can force
## Toolman to redo the tree exploration and dependency files reading stages
## using Toolman's command @qcode{"refresh_cache"}.
##
## @example
## @group
## toolman ('refresh_cache');
## @end group
## @end example
##
## Note also that the @code{toolman ('add_to_path', 'demo_outman');} statement
## has caused Toolman to display the list of the toolboxes that it has added to
## the function search path.  If you don't want the list to be displayed, use
## an output argument, like in the following example.  In this case, the list
## is returned as a cell array of strings.
##
## @example
## @group
## @var{added_to_path} = toolman ('add_to_path', 'demo_outman');
## @end group
## @end example
##
## If you don't want to assign a variable, use tilde (~) instead:
##
## @example
## @group
## [~] = toolman ('add_to_path', 'demo_outman');
## @end group
## @end example
##
## One last detail about the @qcode{"add_to_path"} command:  In the examples
## provided, the argument ("demo_outman") is both the name of a toolbox and the
## name of a function.  The argument to the @qcode{"add_to_path"} command can
## actually be any of the following things:
##
## @itemize @bullet
## @item
## The name of a function (example: "home_dir").
##
## @item
## The base name of a function file (example: "home_dir.m").
##
## @item
## The path to a toolbox, similar to the toolbox paths used in the dependency
## files (examples: "env", "atomm/env").  Please see the dependency file
## writing rule #5 above.
## @end itemize
##
## Providing no argument to the @qcode{"add_to_path"} command is equivalent to
## providing @code{pwd} (i.e.@ the path to the current working directory) as
## argument.
##
## Beside the @qcode{"add_to_path"} command, Toolman provides a similar command
## called @qcode{"list_declared_deps"}.  The difference is that it does not add
## the dependencies to the function search path but only displays them.
## Command @qcode{"list_declared_deps"} displays its output even if an output
## argument is used.  Example:
##
## @example
## @group
## @var{list} = toolman ('list_declared_deps', 'demo_outman');
## @end group
## @end example
##
## @strong{Run test cases using Toolman's command @qcode{"run_test"}.}
##
## Another major command provided by Toolman is @qcode{"run_test"}.  It is
## similar to the @qcode{"add_to_path"} command but with two important
## differences:
##
## @itemize @bullet
## @item
## @qcode{"run_test"} also adds the test cases of the dependencies to the
## function search path.
##
## @item
## @qcode{"run_test"} runs the test cases of the dependencies and outputs a
## test report using function @code{report_test_rslt}.
## @end itemize
##
## Example:
##
## @example
## @group
## @var{added_to_path} = toolman ('run_test', 'home_dir');
## @end group
## @end example
##
## @strong{Configure Toolman, especially regarding sources locations.}
##
## Now that we have covered the main commands provided by Toolman, let's see
## how Toolman can be tweaked to the users' needs via the configuration
## parameters.
##
## A very important configuration parameter is @qcode{"top"}.  It is a cell
## array of strings providing the list of the source trees to be explored by
## toolman.  If there is only one source tree to explore, then @qcode{"top"}
## can be a simple string.  It is the case by default as @qcode{"top"} defaults
## to @code{pwd} (i.e.@ the current working directory).
##
## You can specify a specific list of source trees to explore by providing the
## @qcode{"top"} configuration parameter in the command used for the first
## invocation of Toolman.  In this context, the first invocation is the first
## call to function @code{toolman} after the startup of Octave or Matlab or the
## first call to function @code{toolman} after having shutting it down using
## the @qcode{"quit"} command.  Example:
##
## @example
## @group
## toolman ('add_to_path', 'a_function', ...
##     '--', 'top', @{'a/source/tree', 'another/tree'@});
## toolman ('quit'); % Shut down Toolman.
## toolman ('add_to_path', 'f', '--', 'top', 'yet/another/one');
## @end group
## @end example
##
## Note the "---" argument.  It serves as a separator between the command
## arguments ("a_function" or "f") and the configuration parameters.
##
## Note also that the example above is designed to illustrate the use of the
## @qcode{"quit"} command to shut down Toolman and allow a new startup with
## different configuration parameters (the second @code{toolman ('add_to_path',
## ...)} statement would issue an error if the @code{toolman ('quit');}
## statement were absent).  You could achieve the same result in terms of
## function search path with the two following statements:
##
## @example
## @group
## toolman ('add_to_path', 'a_function', '--', 'top', ...
##     @{'a/source/tree', 'another/tree', 'yet/another/one'@});
## toolman ('add_to_path', 'f');
## @end group
## @end example
##
## Another possibility is to use Toolman's @qcode{"configure"} command to
## provide the configuration parameters, and then issue the
## @code{toolman ('add_to_path', ...)} statements.  Example:
##
## @example
## @group
## toolman ('configure', 'top', ...
##     @{'a/source/tree', 'another/tree', 'yet/another/one'@});
## toolman ('add_to_path', 'a_function');
## toolman ('add_to_path', 'f');
## @end group
## @end example
##
## It is not mandatory to use a "---" argument in the
## @code{toolman ('configure', ...)} statement because the @qcode{"configure"}
## command takes a fixed number (which happens to be zero) of command
## arguments.  But a "---" argument would do no harm:
##
## @example
## @group
## toolman ('configure', '--', 'top', ...
##     @{'a/source/tree', 'another/tree', 'yet/another/one'@});
## @end group
## @end example
##
## If you want to configure Toolman with all its default configuration
## parameters, issue one of the following statements.  The third one exploits
## the fact that @qcode{configure} is the default command for Toolman.
##
## @example
## @group
## toolman ('configure');
## toolman ('configure', '--');
## toolman ();
## @end group
## @end example
##
## Other configuration parameters are:
##
## @table @asis
## @item @qcode{"test_case_tb_reg_exp"}
## A regular expression@footnote{All the regular expressions mentioned in this
## documentation are parsed using function @code{regexp} and thus must conform
## to the regular expression syntax used by @code{regexp}.} that the name of a
## test case subdirectory must match.  The default value for this configuration
## parameter is "^test_", which matches the name of the test case
## subdirectories in the Atomm source tree (i.e.@ "test_case").  It is
## recommended to stick to this naming scheme.
##
## @item @qcode{"test_case_reg_exp"}
## A regular expression that the name of a test case must match.  The default
## value for this configuration parameter is "^test_", which matches the name
## of the test cases in the Atomm source tree (examples: @code{test_env},
## @code{test_math}).  Here again, it is recommended to stick to this naming
## scheme.
##
## @item Outman's configuration parameters
## Outman's configuration parameters are also applicable to Toolman.  The most
## interesting Outman configuration parameters for a Toolman user are probably
## @qcode{"logdir"} and @qcode{"logname"}.  They allow to specify a log file
## (No log file is specified by default).  If a log file is specified, then
## Toolman writes the following information to it:
##
## @itemize @bullet
## @item
## The list of toolboxes computed by the @qcode{"add_to_path"},
## @qcode{"list_declared_deps"} and @qcode{"run_test"} commands.
##
## @item
## The test report output by the @qcode{"run_test"} command.
## @end itemize
##
## The following examples show two ways of specifying a log file along with the
## @qcode{"top"} configuration parameter:  One using "name-value pairs", the
## other one using a structure.
##
## Example 1 (name-value pairs)
##
## @example
## @group
## toolman ('configure', '--', ...
##     'top', @{'a/source/tree', 'another/tree'@}, ...
##     'logdir', 'path/to/desired/log/directory', ...
##     'logname', 'toolman.log');
## @end group
## @end example
##
## Example 2 (structure)
##
## @example
## @group
## toolman ('configure', struct (...
##     'top', @{'a/source/tree', 'another/tree'@}, ...
##     'logdir', 'path/to/desired/log/directory', ...
##     'logname', 'toolman.log'));
## @end group
## @end example
##
## Note that if Toolman is not the master caller of Outman (i.e.@ a connection
## to Outman has already been opened when Toolman connects to Outman), then the
## Outman configuration parameters specified via Toolman are ignored and Outman
## configuration is as set by the master caller of Outman.
##
## Note also that the log file (if any) may not be closed until all connections
## to Outman are closed.  This may cause the illusion that some messages that
## are expected to be written to the log file are not written.  They actually
## appear in the log file when all connections to Outman are closed.
##
## Please run @code{help outman} for more information about Outman.
## @end table
##
## @strong{Tweak Toolman's default configuration to your needs.}
##
## You can force customized default configuration parameter values to be used
## instead of the "factory defined" ones by setting the application data
## @qcode{"toolman"} for handle 0 to a structure containing the customized
## default configuration parameter values.  Example:
##
## @example
## @group
## setappdata (0, 'toolman', struct (...
##     'top', @{@{'a/source/tree', 'another/tree'@}@}, ...
##     'logdir', 'path/to/desired/log/directory', ...
##     'logname', 'toolman.log'));
## @end group
## @end example
##
## If you want to use these customized configuration parameter values
## permanently, add the @code{setappdata (0, 'toolman', ...)} statement to a
## startup file so that you don't have to type it every time you launch Octave
## or Matlab.
##
## The @qcode{"configure"} command returns Toolman's configuration parameters
## as a structure.  So does the @qcode{"get_config"} command.
## @qcode{"get_config"} is actually an alias for @qcode{"configure"}.
##
## The @qcode{"get_config_origin"} also returns a structure with one field for
## every configuration parameters, but the field values are strings giving
## information about the origin of the configuration parameter values.  The
## strings are all one of the following strings:
##
## @table @asis
## @item "Default"
## Means that the configuration parameter has been set to its "factory defined"
## default value.
##
## @item "Session specific configuration (getappdata(0, 'toolman'))"
## Means that the configuration parameter has been set to a customized value
## via the application data @qcode{"toolman"} for handle 0.
##
## @item "Configuration argument on first call to toolman"
## Means that the configuration parameter value has been provided as a
## configuration argument in the command used for the first invocation of
## Toolman.
## @end table
##
## @seealso{addpath, cd, checkmtree, enable_toolman, genpath, outman, pwd,
## report_test_rslt, run, setappdata}
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

    if cmd.(cmdName).no_return_value
        minCmdOutputArgCount = 0;
    else
        minCmdOutputArgCount = 1;
    endif
    CmdOutputArgCount = max([minCmdOutputArgCount nargout]);
    try
        [clearAppRequested, state, varargout{1 : CmdOutputArgCount}] ...
            = run_command(cmdName, cmdArg, config, configOrigin, state, ...
                nargout, name);
        commandError = false;
    catch e
        clearAppRequested = ~cfLocked;
        commandError = true;
    end_try_catch

    cfLocked = true;

    if clearAppRequested
        munlock;
        clear(mfilename);
    else
        mlock;
    endif

    if commandError
        rethrow(e);
    endif

endfunction

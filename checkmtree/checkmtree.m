## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {stru =} checkmtree ('check_code', ...)
## @deftypefnx {Function File} {stru =} checkmtree ('check_encoding', ...)
## @deftypefnx {Function File} {stru =} checkmtree ('check_dependencies', ...)
## @deftypefnx {Function File} {stru =} checkmtree ('check_all', ...)
## @deftypefnx {Function File} checkmtree {@
## tb_deps =} ('list_toolbox_deps', @var{toolbox_relative_or_absolute_path})
## @deftypefnx {Function File} {deps =} checkmtree ('list_deps')
## @deftypefnx {Function File} {config =} checkmtree ('configure', '--', @var{@
## config_param_1_name}, @var{config_param_1_value}, @var{@
## config_param_2_name}, @var{config_param_2_value}, ...)
## @deftypefnx {Function File} {config =} checkmtree ('configure', '--', @var{@
## config_params_as_a_structure})
## @deftypefnx {Function File} {config =} checkmtree ('get_config')
## @deftypefnx {Function File} {@
## config_origin =} checkmtree ('get_config_origin')
## @deftypefnx {Function File} checkmtree ('quit')
##
## Check M-file trees (encoding, code, dependencies).
##
## @strong{Checkmtree can run @code{checkcode} on all your M-files at once.}
##
## @code{checkcode} is a function provided with Matlab (not with Octave at the
## time of this writing) that allows to check an M-file for possible issues in
## the code.  One functionality of Checkmtree is to run @code{checkcode}
## recursively on whole source trees with only one statement.
##
## For example, the following command runs @code{checkcode} on all the M-files
## located in the current directory and its subdirectories.  In this command,
## @qcode{"check_code"} is the name of a Checkmtree command.
##
## @example
## @group
## @var{stru} = checkmtree ('check_code');
## @end group
## @end example
##
## You can specify a specific directory tree by providing the name of the top
## directory of the tree as argument:
##
## @example
## @group
## @var{stru} = checkmtree ('check_code', 'a/source/tree');
## @end group
## @end example
##
## You can also specify multiple directory trees by providing the names of the
## top directories for the trees in a cell array:
##
## @example
## @group
## @var{stru} = checkmtree ('check_code', ...
##     @{'a/source/tree', 'another/tree'@});
## @end group
## @end example
##
## @var{stru} is a structure having the following fields:
##
## @table @asis
## @item m_file_count
## Number of analyzed M-files.
##
## @item max_m_file_byte_size
## Byte size of the largest analyzed M-files.
## @end table
##
## @strong{Checkmtree can also check the encoding of your M-files.}
##
## If your M-files are supposed to be encoded in one of the following, then
## Checkmtree can check via its @qcode{"check_encoding"} command that the
## encoding is actually as expected:
##
## @itemize @bullet
## @item ASCII
##
## @item ISO 8859
##
## @item UTF-8
##
## @item Windows-1252
## @end itemize
##
## Note that the algorithm used for the UTF-8 encoding checking is a simplified
## one and may in some cases yield erroneous results.
##
## The following command checks the encoding of the M-files located in the
## current directory and its subdirectories.  By default, Checkmtree is
## configured to check that the M-files are encoded in ASCII.
##
## @example
## @group
## @var{stru} = checkmtree ('check_encoding');
## @end group
## @end example
##
## Like for the @qcode{"check_code"} command, you can specify one or multiple
## directory trees to check.  Just provide the names of the top directories for
## the trees in a cell array.  It can be a simple string if there is only one
## tree.
##
## @var{stru} is here similar to the structure returned by Checkmtree's
## @qcode{"check_code"} command.
##
## Change the value for  the @qcode{"m_file_char_set"} configuration parameter
## if your M-files are not encoded in ASCII but in one of the other supported
## character sets. The allowed values for the @qcode{"m_file_char_set"}
## configuration parameter are:
##
## @itemize @bullet
## @item "ascii"
##
## @item "iso8859"
##
## @item "utf8"
##
## @item "win1252"
## @end itemize
##
## For example, if your M-files are encoded in Windows-1252, set the
## @qcode{"m_file_char_set"} configuration parameter to "win1252" in the
## command used for the first invocation of Toolman, like in the following
## examples:
##
## @example
## @group
## @var{stru} = checkmtree ('check_encoding', '--', ...
##     'm_file_char_set', 'win1252');
## @end group
## @end example
##
## @example
## @group
## @var{stru} = checkmtree ('check_encoding', ...
##     @{'a/source/tree', 'another/tree'@}, '--', ...
##     'm_file_char_set', 'win1252');
## @end group
## @end example
##
## Note that to check the encoding of a file, Checkmtree does not always read
## the file entirely.  By default it does not read more than 100000 bytes from
## a file.  If you find this value is not appropriate, you can set another one
## via the @qcode{max_read_bytes} configuration parameters, like in the
## following example:
##
## @example
## @group
## @var{stru} = checkmtree ('check_encoding', '--', ...
##     'max_read_bytes', '500');
## @end group
## @end example
##
## Checkmtree's configuration mechanism is identical to Toolman's configuration
## mechanism.  Please see the documentation for Toolman (issue a @code{help
## toolman} command) for all the details about:
##
## @itemize @bullet
## @item
## How to set the configuration parameters;
##
## @item
## What the first invocation is and how to shut down (for Checkmtree, the shut
## down can be done using @code{checkmtree ('quit')};
##
## @item
## What the "---" argument is;
##
## @item
## how to customize the default values for the configuration parameters using
## @code{setappdata}.  For Checkmtree, use a
## @code{setappdata (0, 'checkmtree', ...)} statement;
##
## @item
## how to get the Checkmtree's configuration parameters;
##
## @item
## how to get the origin for Checkmtree's configuration parameters.
## @end itemize
##
## Like for Toolman, Outman's configuration parameters are applicable to
## Checkmtree.
##
## @strong{Last but not least, Checkmtree can check your dependency files.}
##
## Checkmtree has a @qcode{"check_dependencies"} command that checks the
## dependency files.  More precisely, it checks that:
##
## @itemize @bullet
## @item
## The dependency files are properly written;
##
## @item
## Do not declare any superfluous dependencies;
##
## @item
## Do not omit any dependencies.
## @end itemize
##
## Please see the documentation for Toolman (run @code{help toolman}) for all
## the details about the dependency files.
##
## Checkmtree's @qcode{"check_dependencies"} command analyses the code in the
## M-files to determine if the name of functions of other toolboxes appear and
## deduce which are the dependencies.  The algorithm used is not smart enough
## to find if a name is a function name or a variable name and may yield false
## warnings.  You are encouraged to not use variables identifiers that are also
## function names.  Also functions that are called only via the @code{eval}
## function or a similar function are not detected.  Try to ensure that all the
## functions you use are called at least once in an M-file of the toolbox using
## a "normal" function call.
##
## Warning: @emph{Checkmtree's @qcode{"check_dependencies"} command is slow}
## and can easily take minutes to run even on source trees of moderate size.
##
## The @qcode{"check_dependencies"} command includes the encoding checking that
## the @qcode{"check_encoding"} performs.
##
## Like for the commands mentioned above, you can specify one or multiple
## directory trees to check.  Just provide the names of the top directories for
## the trees in a cell array.  It can be a simple string if there is only one
## tree.  If no directory is specified, then the working directory is checked.
##
## @example
## @group
## @var{stru} = checkmtree ('check_dependencies');
## @end group
## @end example
##
## @example
## @group
## @var{stru} = checkmtree ('check_dependencies', 'a/source/tree');
## @end group
## @end example
##
## @example
## @group
## @var{stru} = checkmtree ('check_dependencies', ...
##     @{'a/source/tree', 'another/tree'@});
## @end group
## @end example
##
## @var{stru} is a structure having the following fields:
##
## @table @asis
## @item m_file_count
## Number of analyzed M-files.
##
## @item max_m_file_byte_size
## Byte size of the largest analyzed M-files.
##
## @item cum_line_count
## Cumulative number of lines in the analyzed M-files.
##
## @item cum_sloc_count
## Cumulative number of lines of code (lines that are not empty and don't
## contain only a comment) in the analyzed M-files.
## @end table
##
## Note that Checkmtree has a command called @qcode{"check_all"} that performs
## all the checks at once: @code{checkcode}, encoding and dependencies.
##
## After having executed a Checkmtree's @qcode{"check_dependencies"} or
## @qcode{"check_all"} command, you can use two complementary commands:
## @qcode{"list_toolbox_deps"} and @qcode{"list_deps"}.
##
## @table @asis
## @item @qcode{"list_toolbox_deps"}
## This command lists the dependencies for a toolbox.  For example, to get the
## dependencies for the "env" toolbox in the Atomm source tree, run first the
## @qcode{"check_dependencies"} command on the Atomm source tree and then run
## the @qcode{"list_toolbox_deps"} command with an absolute or relative path to
## the "env" toolbox provided as argument.  It can be "env" or "atomm/env" for
## instance.  The documentation for Toolman gives some details about this.
##
## @example
## @group
## checkmtree ('check_dependencies', 'path/to/atomm');
## @var{tb_deps} = checkmtree ('list_toolbox_deps', 'env');
## @end group
## @end example
##
## The returned value (@var{tb_deps} in the example) is a 2-row cell array.
## The first row contains the names of the functions from other toolboxes that
## are called by the functions in the toolbox provided as argument.  The second
## row contains the paths to the toolboxes containing the functions in the
## first row.
##
## @item @qcode{"list_deps"}
## This command lists the dependencies for all the M-files in the analyzed tree
## that depend on at least one function in another toolbox.  The return value
## is a cell array of strings with 5 columns:
##
## @enumerate
## @item Function name.
##
## @item "public" if the function is public, "private" if it is private.
##
## @item Path to the toolbox containing the function.
##
## @item Name of a function from another toolbox that is called by the function
## in the 1st column.
##
## @item Path to the other toolbox.
## @end enumerate
##
## Example:
##
## @example
## @group
## checkmtree ('check_dependencies', 'path/to/atomm');
## @var{deps} = checkmtree ('list_deps');
## @end group
## @end example
## @end table
##
## @seealso{checkcode, eval, outman, setappdata, toolman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = checkmtree(varargin)

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

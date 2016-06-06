## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} checkmtree ()
## @deftypefnx {Function File} checkmtree ('code')
## @deftypefnx {Function File} checkmtree ('code', @var{top})
## @deftypefnx {Function File} checkmtree ('dependencies')
## @deftypefnx {Function File} checkmtree ('dependencies', @var{top})
## @deftypefnx {Function File} checkmtree ('encoding')
## @deftypefnx {Function File} checkmtree ('encoding', @var{top})
## @deftypefnx {Function File} checkmtree ('all')
## @deftypefnx {Function File} checkmtree ('all', @var{top})
## @deftypefnx {Function File} checkmtree ('toolbox_deps', @var{toolbox})
## @deftypefnx {Function File} checkmtree ('deps_stru')
## @deftypefnx {Function File} checkmtree (..., '--', @var{@
## config_param_1_name}, @var{config_param_1_value}, @var{@
## config_param_2_name}, @var{config_param_2_value}, ...)
## @deftypefnx {Function File} checkmtree (..., '--', @var{s})
## @deftypefnx {Function File} checkmtree ('quit')
##
## @code{checkmtree} is equivalent to @code{checkmtree('all')}.
##
## The first argument to Checkmtree must be one of the follwing command names:
##
## @table @asis
## @item "code"
## Checkmtree applies @code{checkcode} (if available) to the M-files
## recursively found in @var{top}, or in the working directory if @var{top} is
## not provided.  @var{top} can be a cell array of strings containing multiple
## directory names.  In this case M-files are searched in all the directories.
##
## @item "dependencies"
## Checkmtree checks the declared dependencies for the toolboxes.  A toolbox
## in this context is a directory containing at least one M-file.  A toolbox
## may also have a "private" subdirectory that also contains some M-Files.
## The declared dependencies for a toolbox are those read in a file named
## "dependencies" or "dependencies.txt".  The list of the declared dependencies
## for a given toolbox is supposed to be the list of directories that must be
## in the path to be able to use all the functions of the toolbox.  Toolboxes
## that have no dependencies do not need to have a "dependencies" or
## "dependencies.txt" file in their directory.  In "dependencies" or
## "dependencies.txt" files, their must be one toolbox designation per line.
## Empty lines and "end of lines comments" are allowed.  "#" and "%" can be
## used as comment leaders.  A toolbox designation is a toolbox directory base
## name.  One or more parent directory names can be prepended (with a "/" or
## "\" separator) if it is needed to disambigate the toolbox designation.
##
## @item "encoding"
## Checkmtree checks the encoding of the M-files and of the "dependencies" or
## "dependencies.txt".
##
## @item "all"
## Checkmtree performs all the checks (encoding check, @code{checkcode}, and
## dependencies check).
##
## @item "toolbox_deps"
## Checkmtree lists the dependencies for the toolbox @var{toolbox}.
## @var{toolbox} is the kind of toolbox designations that can be found in the
## dependency files.  The return value is a cell array of strings with two
## rows.  The first raw contains the names of the functions from other
## toolboxes that are called by @var{toolbox}.  The second row contains the
## path to the toolboxes containing those functions.
## IMPORTANT: Command "toolbox_deps" is available only if a "dependencies" or a
## "all" command has been run since Checkmtree's startup.  In the other case,
## Checkmtree raises an error.
##
## @item "deps_stru"
## Checkmtree lists the dependencies for all the M-files in the analysed tree
## that depend on at least one function in another toolbox.  The return value
## is a cell array of strings with 5 columns.
## @enumerate
## 1st column: A function name.
##
## 2nd column: "public" if the function is public or "private" if it is
## private.
##
## 3rd column: Path to the toolbox containing the function.
##
## 4th column: Name of a function from another toolbox that is called by the
## function in 1st column.
##
## 5th column: Path to the other toolbox.
## @end enumerate
## IMPORTANT: Command "deps_stru" is available only if a "dependencies" or a
## "all" command has been run since Checkmtree's startup.  In the other case,
## Checkmtree raises an error.
## @end table
##
## Note that when the provided command name is "dependencies", the M-files
## encoding is checked also.
##
## Note also that when the provided command name is "dependencies" or "all",
## Checkmtree returns a structure with the following four fields.
## Only the first two are present in the returned structure when the command
## name is "encoding" or "code".
##
## @enumerate
## @item m_file_count: Number of analysed M-files.
##
## @item max_m_file_byte_size: Byte size of the largest analysed M-Files.
##
## @item cum_line_count: Cumulative number of lines in the analysed M-files.
##
## @item cum_sloc_count: Cumulative number of lines of code (lines that are
## not empty and don't contain only a comment) in the analysed M-files.
## @end enumerate
##
## Checkmtree uses Outman for its output.  Outman's configuration parameters
## can be provided via Checkmtree's command line after a "--" argument.  They
## can be provided as "name-value pairs" or as a structure @var{s}.  Please
## see the documentation for @code{outman_connect_and_config_if_master} for
## more details about Outman's configuration parameters.
##
## Checkmtree has two configuration parameters.  One is named "m_file_char_set"
## and can have one of the following values:
##
## @table @asis
## @item "ascii" (default value)
## M-files are expected to be ASCII encoded text files.
##
## @item "iso8859"
## M-files are expected to be ISO-8859 encoded text files.
##
## @item "utf8"
## M-files are expected to be UTF-8 encoded text files.
##
## @item "win1252"
## M-files are expected to be Windows-1252 encoded text files.
## @end table
##
## The second configuration parameter is named "max_read_bytes" and is the
## maximum number of bytes that is read in an M-file when checking its
## encoding.  It defaults to 100000.
##
## To set the configuration parameters to specific (non default) values,
## provide them on the Checkmtree's command line after the "--" argument along
## with the Outman's configuration parameters.
##
## Note that you can also alter the default configuration parameter values by
## assigning first a structure using a
## @code{setappdata(0, 'checkmtree', @var{s})} instruction.
##
## Once Checkmtree has been configured, a @code{checkmtree ('quit')} command
## must be issued to be able to reconfigure it.
##
## @seealso{checkcode, outman, outman_connect_and_config_if_master}
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

    cfLocked = true;

    [clearAppRequested, state, varargout{1 : max([1 nargout])}] ...
        = run_command(cmdName, cmdArg, config, configOrigin, state, name);

    if clearAppRequested
        munlock;
        clear(mfilename);
    else
        mlock;
    endif

endfunction

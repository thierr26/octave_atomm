## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{cmd_nam}, @var{cmd_arg}, @var{@
## config_arg}] =} command_and_config_args (@var{arg}, @var{s})
##
## Extract command and configuration arguments from application argument list.
##
## @code{command_and_config_args} is used by applications like Mental
## Sum@footnote{Mental Sum is a simple demonstration application aiming at
## demonstrating how the applications provided in the Atomm source tree
## (Toolman, Checkmtree and Outman) are build.  Please issue a @code{help
## mentalsum} command for all the details.} to extract the command name, the
## command arguments and the configuration arguments from the argument list.
##
## The argument list is provided as a cell array (@var{arg}).
## @code{command_and_config_args} assumes @var{arg} is a return value of
## @code{command_alias_expansion} and has been validated by
## @code{check_command_name}.
##
## The second argument to @code{command_and_config_args} is the application
## command structure (@var{s}).  @code{command_and_config_args} assumes it has
## been validated beforehand by @code{check_command_stru_and_default}.
##
## @code{command_and_config_args} returns the command name (the first argument
## to the application) in @var{cmd_nam}, the command arguments in @var{cmd_arg}
## and the configuration arguments in @var{config_arg}.  Both @var{cmd_arg} and
## @var{config_arg} are cell arrays.
##
## In the case of a command taking a variable number of arguments, the user
## must separate explicitly the command arguments and the configuration
## arguments with a "---" argument.
##
## @seealso{check_command_name, check_command_stru_and_default,
## command_alias_expansion, mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [cmd_nam, cmd_arg, config_arg] = command_and_config_args(arg, s)

    # Get the command name (the first argument).
    cmd_nam = arg{1};

    # Get the validation function for the command arguments.
    c_arg_valid = s.(cmd_nam).valid;

    # Search for the first "--" argument.
    doubleHyphen = repmat('-', 1, 2);
    sepArgPos = find_string_first_occurrence_in_cell_array(doubleHyphen, arg);

    narginVFun = nargin(c_arg_valid);
    if narginVFun >= 0
        # The command expects a fixed number of arguments.
        nExpectedCArgs = narginVFun;
    else
        # The command expects a fixed number of arguments and narginVFun is the
        # opposite of the minimum number of arguments plus one.
        nExpectedCArgs = -(narginVFun + 1);
    endif

    # Number of given arguments that may be command arguments.
    if sepArgPos == 0
        nGivenCArgs = numel(arg) - 1;
    else
        nGivenCArgs = sepArgPos - 2;
    endif

    config_arg = {};
    if narginVFun >= 0
        # The command expects a fixed number of arguments.

        if nGivenCArgs >= nExpectedCArgs
            cmd_arg = arg(2 : nExpectedCArgs + 1);
            if nGivenCArgs > nExpectedCArgs || sepArgPos ~= 0
                if sepArgPos == 0
                    config_arg = arg(nExpectedCArgs + 2 : end);
                elseif sepArgPos == nExpectedCArgs + 2
                    config_arg = arg(nExpectedCArgs + 3 : end);
                else
                    error(['Unexpected "%s" as argument number %d. ' ...
                        'Command %s expects %d argument(s), not %d'], ...
                        doubleHyphen, sepArgPos, cmd_nam, ...
                        nExpectedCArgs, nGivenCArgs);
                endif
            endif
        else
            error(['Not enough arguments for command %s ' ...
                '(%d expected, %d given)'], cmd_nam, nExpectedCArgs, ...
                nGivenCArgs);
        endif
    else
        # The command takes a variable number of arguments.

        if nGivenCArgs >= nExpectedCArgs
            cmd_arg = arg((1 : nGivenCArgs) + 1);
            if numel(arg) > nGivenCArgs + 1
                # Argument at position nGivenCArgs + 2 is "--".
                config_arg = arg(nGivenCArgs + 3 : end);
            endif
        else
            error(['Wrong number of arguments for command %s (at least %d ' ...
                'expected, %d given)'], cmd_nam, nExpectedCArgs, nGivenCArgs);
        endif
    endif

endfunction

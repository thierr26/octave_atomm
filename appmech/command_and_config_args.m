## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{cmd_nam}, @var{cmd_arg}, @var{@
## config_arg}] =} command_and_config_args (@var{arg}, @var{s})
##
## Get command name, command arguments and configuration arguments.
##
## @code{command_and_config_args} implements one of the mechanics used by
## applications like @code{hello} and @code{outman}: the separation of command
## arguments and configuration arguments.
##
## @var{arg} is a cell array containing all the arguments to the application as
## returned by @code{command_alias_expansion}.  @code{command_and_config_args}
## assumes that it has been checked beforehand by
## @code{check_command_name}.
##
## @var{s} is the "command structure" for the application.
## @code{command_and_config_args} assumes it has been checked beforehand by
## @code{check_command_stru_and_default}.  Please see the help for
## @code{check_command_stru_and_default} for more information on the "command
## structure".
##
## @code{command_and_config_args} returns the command name (the first argument
## to the application) in @var{cmd_nam}, the command arguments in @var{cmd_arg}
## and the configuration arguments in @var{config_arg}.  Both @var{cmd_arg} and
## @var{config_arg} are cell arrays.
##
## @seealso{check_command_name, check_command_stru_and_default,
## command_alias_expansion, hello, outman}
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

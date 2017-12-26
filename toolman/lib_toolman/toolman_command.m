## Copyright (C) 2016-2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{s}, @var{default}] =} toolman_command ()
## @deftypefnx {Function File} {@var{ret} =} toolman_command (@var{@
## c}, 'quit_command')
## @deftypefnx {Function File} {@var{ret} =} toolman_command (@var{@
## c}, 'verbose_command')
## @deftypefnx {Function File} {@var{ret} =} toolman_command (@var{@
## c}, 'quiet_command')
## @deftypefnx {Function File} {@var{ret} =} toolman_command (@var{@
## c}, 'auto_verbose_command')
## @deftypefnx {Function File} {@var{ret} =} toolman_command (@var{@
## c}, 'add_to_path_command')
## @deftypefnx {Function File} {@var{ret} =} toolman_command (@var{@
## c}, 'run_test_command')
## @deftypefnx {Function File} {@var{ret} =} toolman_command (@var{@
## c}, 'refresh_cache_command')
##
## Toolman's commands related information.
##
## Called without argument, @code{toolman_command} returns two output
## arguments:
##
## @table @asis
## @item @var{s}
## Toolman's command structure.  Please see the documentation for
## @code{mentalsum} for details about how applications like Toolman are built
## and what is the command structure.
##
## @item @var{default}
## Toolman's default command.
## @end table
##
## These two output arguments are the kind of variables to be used as input
## arguments to @code{check_command_stru_and_default}.  Please see the
## documentation for @code{check_command_stru_and_default} for a more precise
## description of @var{s}.
##
## Called with two arguments, @code{toolman_command} returns one logical
## output argument (@var{ret}).  @var{ret} is true if @var{c} (a string
## supposed to be the name of a Toolman command) is of the "type" provided
## as second argument.
##
## The defined "types" are:
##
## @itemize @bullet
## @item 'quit_command'
##
## @item 'verbose_command'
##
## @item 'quiet_command'
##
## @item 'auto_verbose_command'
##
## @item 'add_to_path_command'
##
## @item 'run_test_command'
##
## @item 'refresh_cache_command'
## @end itemize
##
## Note that some commands may be of no "types", whereas other commands are of
## one or more "types".
##
## @seealso{check_command_stru_and_default, toolman, mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = toolman_command(varargin)

    if nargin == 0

        varargout{2} = 'configure';
        varargout{1} = struct(...
            varargout{2}, struct(...
                'valid', @is, ...
                'no_return_value', false), ...
            'quit', struct(...
                'valid', @is, ...
                'no_return_value', true), ...
            'list_declared_deps', struct(...
                'valid', @string_arg_or_none, ...
                'no_return_value', false), ...
            'add_to_path', struct(...
                'valid', @string_or_cellstr_arg_or_none, ...
                'no_return_value', false), ...
            'run_test', struct(...
                'valid', @string_or_cellstr_arg_or_none, ...
                'no_return_value', false), ...
            'run_all_tests', struct(...
                'valid', @is, ...
                'no_return_value', false), ...
            'refresh_cache', struct(...
                'valid', @is, ...
                'no_return_value', true), ...
            'get_config_origin', struct(...
                'valid', @is, ...
                'no_return_value', false));

    else

        try
            validated_mandatory_args(...
                {@is_non_empty_string, @is_non_empty_string}, varargin{:});
        catch
            error('Zero or two arguments expected (non empty strings)');
        end_try_catch

        switch varargin{2}

            case 'quit_command'
                varargout{1} = strcmp(varargin{1}, 'quit');

            case 'verbose_command'
                varargout{1} = strcmp(varargin{1}, 'list_declared_deps');

            case 'quiet_command'
                varargout{1} = ~strcmp(varargin{1}, 'list_declared_deps') ...
                    && ~strcmp(varargin{1}, 'add_to_path') ...
                    && ~is_prefixed_with(varargin{1}, 'run_');

            case 'auto_verbose_command'
                varargout{1} = strcmp(varargin{1}, 'add_to_path') ...
                    || is_prefixed_with(varargin{1}, 'run_');

            case 'refresh_cache_command'
                varargout{1} = strcmp(varargin{1}, 'refresh_cache');

            case 'add_to_path_command'
                varargout{1} = strcmp(varargin{1}, 'add_to_path') ...
                    || is_prefixed_with(varargin{1}, 'run_');

            case 'run_test_command'
                varargout{1} = is_prefixed_with(varargin{1}, 'run_');

            otherwise
                error('Undefined Toolman command type: %s', varargin{2});

        endswitch

    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{s}, @var{default}] =} checkmtree_command ()
## @deftypefnx {Function File} {@var{ret} =} checkmtree_command (@var{@
## c}, 'quit_command')
## @deftypefnx {Function File} {@var{ret} =} checkmtree_command (@var{@
## c}, 'tree_checking_command')
## @deftypefnx {Function File} {@var{ret} =} checkmtree_command (@var{@
## c}, 'code_checking_command')
## @deftypefnx {Function File} {@var{ret} =} checkmtree_command (@var{@
## c}, 'encoding_checking_command')
## @deftypefnx {Function File} {@var{ret} =} checkmtree_command (@var{@
## c}, 'dependencies_checking_command')
## @deftypefnx {Function File} {@var{ret} =} checkmtree_command (@var{@
## c}, 'listing_command')
## @deftypefnx {Function File} {@var{ret} =} checkmtree_command (@var{@
## c}, 'toolbox_dependencies_listing')
## @deftypefnx {Function File} {@var{ret} =} checkmtree_command (@var{@
## c}, 'full_dependencies_listing')
##
## Checkmtree's commands related information.
##
## Called without argument, @code{checkmtree_command} returns two output
## arguments:
##
## @table @asis
## @item @var{s}
## Checkmtree's command structure.  Please see the documentation for
## @code{mentalsum} for details about how applications like Checkmtree are
## built and what is the command structure.
##
## @item @var{default}
## Checkmtree's default command.
## @end table
##
## These two output arguments are the kind of variables that can be used as
## input arguments to @code{check_command_stru_and_default}.  Please see the
## documentation for @code{check_command_stru_and_default} for a more precise
## description of @var{s}.
##
## Called with two arguments, @code{checkmtree_command} returns one logical
## output argument (@var{ret}).  @var{ret} is true if the first argument
## (@var{c}, a string supposed to be the name of a Checkmtree command) is of
## the "type" provided as second argument.
##
## The defined "types" are:
##
## @itemize @bullet
## @item 'quit_command'
##
## @item 'tree_checking_command'
##
## @item 'code_checking_command'
##
## @item 'encoding_checking_command'
##
## @item 'dependencies_checking_command'
##
## @item 'listing_command'
##
## @item 'toolbox_dependencies_listing'
##
## @item 'full_dependencies_listing'
## @end itemize
##
## Note that some commands may be of no "types", whereas other commands are of
## one or more "types".
##
## @seealso{check_command_stru_and_default, checkmtree, mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = checkmtree_command(varargin)

    if nargin == 0

        varargout{2} = 'configure';
        varargout{1} = struct(...
            varargout{2}, struct(...
                'valid', @is, ...
                'no_return_value', false), ...
            'quit', struct(...
                'valid', @is, ...
                'no_return_value', true), ...
            'check_all', struct(...
                'valid', @string_or_cellstr_arg_or_none, ...
                'no_return_value', false), ...
            'check_encoding', struct(...
                'valid', @string_or_cellstr_arg_or_none, ...
                'no_return_value', false), ...
            'check_code', struct(...
                'valid', @string_or_cellstr_arg_or_none, ...
                'no_return_value', false), ...
            'check_dependencies', struct(...
                'valid', @string_or_cellstr_arg_or_none, ...
                'no_return_value', false), ...
            'check_toolman_top', struct(...
                'valid', @is, ...
                'no_return_value', false), ...
            'list_toolbox_deps', struct(...
                'valid', @is_non_empty_string, ...
                'no_return_value', false), ...
            'list_deps', struct(...
                'valid', @is, ...
                'no_return_value', false), ...
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

            case 'tree_checking_command'
                varargout{1} = is_prefixed_with(varargin{1}, 'check_');

            case 'code_checking_command'
                varargout{1} = strcmp(varargin{1}, 'check_code') ...
                    || strcmp(varargin{1}, 'check_all') ...
                    || strcmp(varargin{1}, 'check_toolman_top');

            case 'encoding_checking_command'
                varargout{1} = strcmp(varargin{1}, 'check_encoding') ...
                    || strcmp(varargin{1}, 'check_all') ...
                    || strcmp(varargin{1}, 'check_toolman_top');

            case 'dependencies_checking_command'
                varargout{1} = strcmp(varargin{1}, 'check_dependencies') ...
                    || strcmp(varargin{1}, 'check_all') ...
                    || strcmp(varargin{1}, 'check_toolman_top');

            case 'listing_command'
                varargout{1} = is_prefixed_with(varargin{1}, 'list_');

            case 'toolbox_dependencies_listing'
                varargout{1} = strcmp(varargin{1}, 'list_toolbox_deps');

            case 'full_dependencies_listing'
                varargout{1} = strcmp(varargin{1}, 'list_deps');

            otherwise
                error('Undefined Checkmtree command type: %s', varargin{2});

        endswitch

    endif

endfunction

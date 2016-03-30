## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} check_command_stru_and_default (@var{s}, @var{default})
##
## Check application "command structure" and default command name.
##
## @code{check_command_stru_and_default} implements one of the mechanics used
## by applications like @code{hello} and @code{outman}: the check of the
## "command structure" and of the default command name.
##
## The command structure @var{s} has one field for each application command.
## The fields contain function handles.  The functions pointed to by the
## handles are validation functions for the command arguments.  The must take a
## variable number of arguments and return a logical scalar (i.e. they must
## have a signature like @code{ret = f(varargin)}).  If the arguments are valid
## for the command, then the validation function must return true, otherwise it
## must return false or raise an error.
##
## @code{check_command_stru_and_default} checks that the fields of @var{s} are
## function handles and that @var{default} (the application default command) is
## the name of a field of @var{s}.  If it not the case, then an error is
## raised.
##
## @seealso{hello, outman, varargin}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function check_command_stru_and_default(s, default)

    validated_mandatory_args(...
        {@is_non_empty_scalar_structure, ...
        @(str) is_non_empty_string(str) && isfield(s, str)}, s, default);

    [fn, n] = field_names_and_count(s);
    for k = 1 : n
        if ~isa(s.(fn{k}), 'function_handle')
            error('Invalid validation function handle for command %s', fn{k});
        else
            try
                nargin(s.(fn{k}));
            catch
                error(['Invalid validation function (probably a built-in ' ...
                    'function) for command %s'], fn{k});
            end_try_catch
        endif
    endfor

endfunction

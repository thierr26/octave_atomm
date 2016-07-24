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
## Each field is itself a structure with two fields:
##
## @table @asis
## @item "valid"
## Field "valid" must be a function handle.  The function pointed to by the
## handle must be a validation function for the command arguments.  It must
## return a logical scalar.  If the arguments are valid for the command, then
## the validation function must return true, otherwise it must return false or
## issue an error.
##
## Note that function nargin must not issue an error when applied to the
## validation function.  This may preclude the use of built-in functions as
## validation functions.
##
## @item "no_return_value"
## Field "no_return_value" must be a logical scalar (true if the command is not
## supposed to return any value, false otherwise).
## @end table
##
## @code{check_command_stru_and_default (@var{s}, @var{default})} checks that
## the fields of @var{s} are structures with the expected fields and that
## @var{default} (the application default command) is the name of a field of
## @var{s}.  If it not the case, then an error is issued.
##
## @seealso{hello, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function check_command_stru_and_default(s, default)

    validated_mandatory_args(...
        {@is_non_empty_scalar_structure, ...
        @(str) is_non_empty_string(str) && isfield(s, str)}, s, default);

    [fn, n] = field_names_and_count(s);
    for k = 1 : n
        if ~isstruct(s.(fn{k}))
            error(['Invalid command structure. Field "%s" should be a ' ...
                'structure.'], fn{k});
        elseif ~isfield(s.(fn{k}), 'valid') ...
                || ~isfield(s.(fn{k}), 'no_return_value')
            error(['Invalid command structure. Field "%s" should be a ' ...
                'structure with a "valid" field and a "no_return_value" ' ...
                'field.'], fn{k});
        elseif ~isa(s.(fn{k}).valid, 'function_handle')
            error(['Invalid command structure. Field "valid" of field ' ...
                '"%s" should be a function handle'], fn{k});
        elseif ~is_logical_scalar(s.(fn{k}).no_return_value)
            error(['Invalid command structure. Field "no_return_value" of ' ...
                'field "%s" should be a logical scalar'], fn{k});
        else
            try
                nargin(s.(fn{k}).valid);
            catch
                error(['Invalid command structure. Function nargin issues ' ...
                    'an error when applied to the validation function for ' ...
                    'commmand "%s", probably because it is a built-in ' ...
                    'function'], fn{k});
            end_try_catch
        endif
    endfor

endfunction

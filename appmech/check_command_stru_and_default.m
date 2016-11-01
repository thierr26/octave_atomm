## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} check_command_stru_and_default (@var{s}, @var{default})
##
## Check an application command structure and default command name.
##
## @code{check_command_stru_and_default} checks the validity of its two
## arguments @var{s} and @var{default}.  Applications like Mental
## Sum@footnote{Mental Sum is a simple demonstration application aiming at
## demonstrating how the applications provided in the Atomm source tree
## (Toolman, Checkmtree and Outman) are build.  Please issue a @code{help
## mentalsum} command for all the details.} use this function to check the
## command structure and default command name returned by their private
## function @code{command_stru_and_default}.
##
## The command structure @var{s} is supposed to have one field for every
## application command. Every field is itself a structure with two fields:
##
## @table @asis
## @item @qcode{"valid"}
## Handle to a validation function for the command arguments.  The function
## must return a logical scalar and behave as follows:
##
## @itemize @bullet
## @item
## Return true if the arguments are valid arguments for the application
## command.
##
## @item
## Return false or issue an error if the arguments are not valid for the
## application command.
## @end itemize
##
## It can eventually be an anonymous function.
##
## Note that function @code{nargin} must not issue an error when applied to the
## validation function.  This may preclude the use of built-in functions as
## validation functions.
##
## @item @qcode{"no_return_value"}
## Logical scalar (true if the command is not supposed to return any value,
## false otherwise).
## @end table
##
## @code{check_command_stru_and_default (@var{s}, @var{default})} checks that
## the fields of @var{s} are structures with the expected fields and that
## @var{default} (the name of the application default command) is the name of
## a field of @var{s}.  If it not the case, then an error is issued.
##
## @seealso{mentalsum}
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

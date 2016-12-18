## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} check_alias_stru (@var{s}, @var{aliasstru})
##
## Check an application alias structure.
##
## @code{check_alias_stru} checks its @var{aliasstru} argument.  Applications
## like Mental Sum@footnote{Mental Sum is a simple demonstration application
## aiming at demonstrating how the applications provided in the Atomm source
## tree (Toolman, Checkmtree and Outman) are build.  Please issue a @code{help
## mentalsum} command for all the details.} use this function to check the
## alias structure returned by their private function @code{alias_stru}.
##
## The first argument (@var{s}) is the application command structure.
## @code{check_alias_stru} assumes it has been checked beforehand by
## @code{check_command_stru_and_default}.  Please see the help for
## @code{check_command_stru_and_default} for more information on the command
## structure.
##
## @var{aliasstru} is the alias structure for the application.  It is a
## structure in which every field contains the definition for an alias to one
## of the application commands.  The name of the field is the name of the alias
## and the value of the field is supposed to be a cell array.  The first
## element in the cell array must be the name of an application command.  There
## can be zero, one or more other elements in the cell array.  In this case,
## these elements are considered to be arguments to the command.
##
## @code{check_alias_stru} checks that the fields of @var{aliasstru} are cell
## arrays with a non empty string as first element, and that the string is the
## name of a field in @var{s} (i.e.@ is a command for the application).
##
## @seealso{check_command_stru_and_default, mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function check_alias_stru(s, aliasstru)

    validated_mandatory_args({@is_non_empty_scalar_structure, @isstruct}, ...
        s, aliasstru);

    cName = fieldnames(s);
    [aName, nA] = field_names_and_count(aliasstru);
    for k = 1 : nA
        if ~iscell(aliasstru.(aName{k})) || isempty(aliasstru.(aName{k}))
            error('Second argument must must contain non empty cell arrays');
        elseif ~is_non_empty_string(aliasstru.(aName{k}){1})
            error(['Cell arrays in second argument must have a non empty ' ...
                'string as first element']);
        elseif ismember(aName{k}, cName)
            error('Invalid alias name (already a command name): %s', ...
                aName{k});
        elseif ~ismember(aliasstru.(aName{k}){1}, cName)
            error('Invalid alias: %s', aliasstru.(aName{k}){1});
        endif
    endfor

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{cf}, @var{ori}] =} apply_config_args (@var{an}, @var{dcf}, @var{@
## cf1}, @var{ori1}, @var{locked}, ...)
##
## Apply application configuration arguments.
##
## @code{apply_config_args} implements one of the mechanics used by
## applications like @code{hello} and @code{outman}: the application of the
## configuration arguments.
##
## The first argument (@var{an}) is the application name.
##
## The second argument (@var{dcf}) is the kind of structure that is used as
## argument to @code{default_config} (default values and validation functions
## for the configuration parameters).  No checking is done on this argument.
## Please see the help for @code{default_config} for details about this
## structure.
##
## The third and fourth arguments (@var{cf1} and @var{ori1}) are supposed to
## be the output arguments of @code{default_config} called with @var{dcf} as
## argument.  No checking is done on these arguments.
##
## The fifth argument (@var{locked}) is a logical flag.  true means that the
## application has already been configured (i.e.@ that the call to the
## application M-file that lead to the call of @code{apply_config_args} is not
## the "startup call" to the application).
##
## @code{apply_config_args} checks that the arguments from the sixth one on are
## valid application configuration arguments with regard to the validation
## function provided in @var{dcf}.  The application configuration arguments (if
## any) must be given as "name-value pairs" (i.e.@ configuration parameter
## names in arguments 6, 8, 10, etc., corresponding configuration parameter
## values in arguments 7, 9, 11, etc.) or as a structure (in this case the
## structure is the sixth and last argument, the names of the fields are the
## names of the configuration parameters and the values in the structure are
## the values of the configuration parameters).  If the application
## configuration arguments are not valid, then an error is raised.
##
## @code{apply_config_args} returns @var{cf} and @var{ori} which are
## @var{cf1} and @var{ori1} with updated values (depending on the configuration
## arguments that have been provided).
##
## If @var{locked} is true and @var{arg} contains configuration parameters
## values that differ from those in @var{cf1}, then @code{apply_config_args}
## raises an error.
##
## @seealso{default_config, hello, outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [cf, ori] = apply_config_args(an, dcf, cf1, ori1, locked, varargin)

    validated_mandatory_args({@is_non_empty_string, @is_logical_scalar}, ...
        an, locked);

    n = nargin - 5;
    if ~is_even(n) && (n ~= 1 || ~isstruct(varargin{1}))
        error('Incomplete name-value pairs list for configuration parameters');
    elseif n == 1 && ~isscalar(varargin{1})
        error('Non scalar structure for configuration parameters');
    endif

    if n == 1
        # Configuration arguments have been given as a structure.

        # Convert this structure to a "name-value pairs" cell array.
        c = struct2namevaluepairs(varargin{1});
        n = numel(c);
    else
        # Configuration arguments have been given as name-value pairs.

        # Check that the names are actually names (non empty strings).
        c = varargin;
        for k = 1 : 2 : n
            if ~is_non_empty_string(c{k})
                error('Invalid name-value pair argument');
            endif
        endfor
    endif

    cf = cf1;
    ori = ori1;
    param = fieldnames(cf1);

    # Loop over the names.
    for k = 1 : 2 : n
        if ~ismember(c{k}, param)
            error('Invalid configuration parameter name: %s', c{k});
        elseif ~dcf.(c{k}).valid(c{k + 1})
            error('Invalid value for configuration parameter %s', c{k});
        elseif locked && ~isequal(c{k + 1}, cf1.(c{k}))
            error(['Too late to change the value for configuration ' ...
                'parameters. You can exit the application and relaunch it '...
                'with new configuration arguments.']);
        elseif ~locked && ~isequal(c{k + 1}, cf1.(c{k}))
            cf.(c{k}) = c{k + 1};
            ori.(c{k}) ...
                = sprintf('Configuration argument on first call to %s', an);
        elseif ~locked && isequal(c{k + 1}, cf1.(c{k}))
            ori.(c{k}) ...
                = sprintf(...
                ['%s (configuration argument with same value has been ' ...
                'ignored)'], ori.(c{k}));
        endif
    endfor

endfunction

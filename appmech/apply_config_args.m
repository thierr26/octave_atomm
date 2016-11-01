## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{cf}, @var{ori}] =} apply_config_args (@var{an}, @var{dcf}, @var{@
## cf1}, @var{ori1}, @var{locked}, @var{config_param_name_1}, @var{@
## config_param_value_1}, @var{config_param_name_2}, @var{@
## config_param_value_2}, ...)
## @deftypefnx {Function File} {@
## [@var{cf}, @var{ori}] =} apply_config_args (@var{an}, @var{dcf}, @var{@
## cf1}, @var{ori1}, @var{locked}, @var{s})
##
## Apply application configuration arguments.
##
## Applications like Mental Sum@footnote{Mental Sum is a simple demonstration
## application aiming at demonstrating how the applications provided in the
## Atomm source tree (Toolman, Checkmtree and Outman) are build.  Please issue
## a @code{help mentalsum} command for all the details.} use
## @code{apply_config_args} to take the configuration arguments provided by the
## user into consideration and overwrite the application default configuration.
##
## The application default configuration must be provided to
## @code{apply_config_args} via arguments @var{cf1} and @var{ori1}.  These
## arguments are supposed to have been output by @code{default_config} and thus
## are supposed to be valid.  No checking is done on them.
##
## The configuration arguments (if any) must be provided via the 6th argument
## on.  They can be provided as name-value pairs or as a structure.
##
## If logical flag @var{locked} is true and some of the values of the
## configuration parameters provided as argument are different from the default
## values, then @code{apply_config_args} issues an error.  Otherwise, @var{cf1}
## and @var{ori1} are output in @var{cf} and @var{ori}, eventually amended
## depending on the configuration parameter values provided as argument.
##
## First and second arguments are the application name (@var{an}) (as returned
## by the application's private function @code{app_name}) and the application
## configuration structure (@var{dcf}).  @var{dcf} is documented in the
## documentation for @code{default_config}.  Please issue a @code{help
## default_config} command to read it.
##
## @seealso{default_config, mentalsum}
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

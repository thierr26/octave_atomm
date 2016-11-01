## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{cf}, @var{ori}] =} default_config (@var{dcf})
## @deftypefnx {Function File} {@
## [@var{cf}, @var{ori}] =} default_config (@var{dcf}, @var{appname})
##
## Application default configuration.
##
## @code{default_config} returns in @var{cf} the default configuration for
## applications like Mental Sum@footnote{Mental Sum is a simple demonstration
## application aiming at demonstrating how the applications provided in the
## Atomm source tree (Toolman, Checkmtree and Outman) are build.  Please issue
## a @code{help mentalsum} command for all the details.}.  The configuration
## for an application is really just a structure.  The fields of the structure
## are the application configuration parameters.
##
## @code{default_config} takes a structure (@var{dcf}) as argument (@var{dcf}).
## It has one field for every configuration parameter.  The fields are themself
## structures with the following fields:
##
## @table @asis
## @item @qcode{"default"}
## "Factory defined" default value for the configuration parameter.
##
## @item @qcode{"valid"}
## Handle to a validation function for the configuration parameter.  The
## function must take exactly one argument, return a logical scalar and behave
## as follows:
##
## @itemize @bullet
## @item
## Return true if the argument is valid.
##
## @item
## Return false or issue an error if the argument is not valid.
## @end itemize
##
## It can eventually be an anonymous function.
## @end table
##
## @code{default_config} checks that the "factory defined" default values are
## valid with regard to the validation functions.
##
## In applications like Mental Sum, @var{dcf} is actually the return value of
## the application'dcf private function @code{config_stru}.
##
## The return structure @var{cf} has the same field list as @var{dcf}.  If the
## optional argument @var{appname} is not provided, then the field values in
## @var{cf} are the "factory defined" default values provided in @var{dcf}.
##
## The second output argument (@var{ori}) is also a structure with the same
## field list, but the field values are strings indicating the origin of the
## configuration parameter value.  If the optional argument @var{appname} is
## not provided, the strings are all "Default".
##
## If the optional argument @var{appname} is provided, then the field values in
## @var{cf} may be different from the "factory defined" default values. It is
## the case when all the following conditions are fulfilled:
##
## @itemize @bullet
## @item
## @var{appname} is a valid variable name (as determined by @code{isvarname});
##
## @item
## A call to @code{getappdata} with 0 as first argument and @var{appname} as
## second argument returns a structure;
##
## @item
## The name of some fields in the structure returned by @code{getappdata} match
## configuration parameter names.
##
## @item
## The value of these fields are valid with regard to the corresponding
## validation functions (the opposite causes @code{default_config} to issue an
## error).
## @end itemize
##
## If the above conditions are fulfilled, then the corresponding field values
## in @var{cf} are those obtained via the @code{getappdata} call and the
## corresponding field values in @var{ori} are strings starting with "Session
## specific configuration".
##
## As already suggested, the "configuration structure" @var{dcf} must have
## fields named after the configuration parameters.  Those fields are themself
## structures with fields "default" (containing the configuration parameters
## default values) and "valid" (containing validation functions similar to
## those used by @code{validated_mandatory_args}).  @code{default_config}
## issues an error if a configuration parameter value (in @var{dcf} or in the
## structure retrieved via the call to @code{getappdata}) is not valid with
## regard to the validation function.
##
## @seealso{getappdata, isvarname, mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [cf, ori] = default_config(dcf, varargin)

    validated_mandatory_args({@is_valid_dflt_s}, dcf);
    appname = validated_opt_args({@is_string, ''}, varargin{:});

    [param, n] = field_names_and_count(dcf);

    desktopData = [];
    if isvarname(appname)
        getappdataCall = ['getappdata(0, ''' appname ''')'];
        desktopData = eval(getappdataCall);
        if ~is_non_empty_scalar_structure(desktopData)
            desktopData = [];
        endif
    endif

    cf = dcf;
    ori = dcf;
    for k = 1 : n

        defaultValue = dcf.(param{k}).default;
        f = dcf.(param{k}).valid;
        oriStr = 'Default';

        if isfield(desktopData, param{k})
            defaultValue = desktopData.(param{k});
            oriStr = ['Session specific configuration (' getappdataCall ')'];

            if ~f(defaultValue)
                error(['Invalid value for configuration parameter ' ...
                    '%s retrieved via %s'], param{k}, getappdataCall);
            endif
        endif

        cf.(param{k}) = defaultValue;
        ori.(param{k}) = oriStr;
    endfor

endfunction

# -----------------------------------------------------------------------------

# Validation function for the configuration structure.

function ret = is_valid_dflt_s(dcf)

    validated_mandatory_args({@(dcf) isstruct(dcf) && isscalar(dcf)}, dcf);
    ret = all(structfun(@is_valid_dflt, dcf));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Validation function for a single field of the configuration parameters
# structure.

function ret = is_valid_dflt(dcf)

    ret = isstruct(dcf) && isfield(dcf, 'default') && isfield(dcf, 'valid') ...
        && isa(dcf.valid, 'function_handle');

    if ret
        f = dcf.valid;
        ret = f(dcf.default);
    endif

endfunction

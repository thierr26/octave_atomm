## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## [@var{conf}, @var{ori}] =} default_config (@var{s})
## @deftypefnx {Function File} {@
## [@var{conf}, @var{ori}] =} default_config (@var{s}, @var{appname})
##
## Application default configuration.
##
## @code{default_config} implements one of the mechanics used by applications
## like @code{hello} and @code{outman}: the evaluation of the application
## default configuration.
##
## The configuration for an application is really just a structure.  The fields
## of the structure are the application configuration parameters.
## @code{default_config} returns this structure (@var{conf}) with the
## configuration parameters set to default values.  It also returns @var{ori}
## which is a structure with the same field list as @var{conf} but the fields
## contain a string which is either "Default" or a string starting with
## "Session specific configuration".
##
## "Default" means that the value in @var{conf} has been taken from the
## "configuration structure" (@var{s}), precisely from the field "default" of
## its field named like the configuration parameter.
##
## "Session specific configuration" means that the value in @var{conf} has been
## taken from a structure retrieved via a call to @code{getappdata} with 0 as
## first argument and @var{appname} as second argument.  It is the case when
## all the following conditions are fulfilled:
##
## @itemize @bullet
##
## @item
## Second argument (@var{appname}) is provided;
##
## @item
## @var{appname} is a valid variable name (as determined by @code{isvarname});
##
## @item
## A call to @code{getappdata} with 0 as first argument and @var{appname} as
## second argument returns a structure;
##
## @item
## The name of a field in the structure returned by @code{getappdata} matches
## the name of the configuration parameter.
## @end itemize
##
## As already suggested, the "configuration structure" @var{s} must have fields
## named after the configuration parameters.  Those fields are themself
## structures with fields "default" (containing the configuration parameters
## default values) and "valid" (containing validation functions similar to
## those used by @code{validated_mandatory_args}).  @code{default_config}
## raises an error if a configuration parameter value (in @var{s} or in the
## structure retrieved via the call to @code{getappdata}) is not valid with
## regard to the validation function.
##
## @seealso{getappdata, hello, isvarname, outman, validated_mandatory_args}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [conf, ori] = default_config(s, varargin)

    validated_mandatory_args({@is_valid_dflt_s}, s);
    appname = validated_opt_args({@is_string, ''}, varargin{:});

    [param, n] = field_names_and_count(s);

    desktopData = [];
    if isvarname(appname)
        getappdataCall = ['getappdata(0, ''' appname ''')'];
        desktopData = eval(getappdataCall);
        if ~is_non_empty_scalar_structure(desktopData)
            desktopData = [];
        endif
    endif

    conf = s;
    ori = s;
    for k = 1 : n

        defaultValue = s.(param{k}).default;
        f = s.(param{k}).valid;
        oriStr = 'Default';

        if isfield(desktopData, param{k})
            defaultValue = desktopData.(param{k});
            oriStr = ['Session specific configuration (' getappdataCall ')'];

            if ~f(defaultValue)
                error(['Invalid value for configuration parameter ' ...
                    '%s retrieved via %s'], param{k}, getappdataCall);
            endif
        endif

        conf.(param{k}) = defaultValue;
        ori.(param{k}) = oriStr;
    endfor

endfunction

# -----------------------------------------------------------------------------

# Validation function for the default configuration parameters structure.

function ret = is_valid_dflt_s(s)

    validated_mandatory_args({@(s) isstruct(s) && isscalar(s)}, s);
    ret = all(structfun(@is_valid_dflt, s));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Validatation function for a single field of the default configuration
# parameters structure.

function ret = is_valid_dflt(s)

    ret = isstruct(s) && isfield(s, 'default') && isfield(s, 'valid') ...
        && isa(s.valid, 'function_handle');

    if ret
        f = s.valid;
        ret = f(s.default);
    endif

endfunction

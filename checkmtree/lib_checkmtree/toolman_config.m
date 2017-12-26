## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} toolman_config ()
## @deftypefnx {Function File} {@var{@
## ret} =} toolman_config (@var{config_param_name})
##
## Toolman's configuration parameters.
##
## @code{@var{ret} = toolman_config ()} returns in @var{ret} Toolman's
## configuration (i.e.@ a structure in which the fields are Toolman's
## configuration parameters).  Toolman's configuration is obtained via a
## @code{toolman('get_config')} call (followed by a @code{toolman('quit')}
## statement if toolman was not running).
##
## @code{@var{ret} = toolman_config (@var{config_param_name})} does the same
## except that only the field named @var{config_param_name}) is returned.
##
## @seealso{toolman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = toolman_config(varargin)

    if nargin > 0
        p = validated_mandatory_args({@is_non_empty_string}, varargin{:});
    endif

    toolmanAlreadyRunning = mislocked('toolman');
    cf = toolman('get_config');
    if ~toolmanAlreadyRunning
        toolman('quit');
    endif

    if nargin == 0
        ret = cf;
    else
        ret = cf.(p);
    endif

endfunction

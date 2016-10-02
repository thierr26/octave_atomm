## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@
## @var{caller_id} = } outman_connect_and_config_if_master ()
## @deftypefnx {Function File} {@
## @var{caller_id} = } outman_connect_and_config_if_master (@var{@
## config_param_1_name}, @var{config_param_1_value}, @var{@
## config_param_2_name}, @var{config_param_2_value}, ...)
## @deftypefnx {Function File} {@
## @var{caller_id} = } outman_connect_and_config_if_master (@var{stru})
##
## Connect to Outman.
##
## @code{@var{caller_id} = outman_connect_and_config_if_master ()} connects to
## Outman and returns a caller ID.
##
## Configuration parameters can be provided as arguments, as name-value pairs
## or as a structure.  They are ignored if the caller is not Outman's master
## caller.
##
## Outman usage and configuration is fully documented in the help for Outman.
## Please issue a @code{help outman} command to read it.
##
## @seealso{outman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [caller_id, master] = outman_connect_and_config_if_master(varargin)

    master = ~mislocked('outman');
    if master
        # Start and configure Outman.
        [~, caller_id] = outman('configure', '--', varargin{:});
    else
        # Connect to Outman without attempting to configure it (which would
        # cause an error).
        caller_id = outman('connect');
    endif

endfunction

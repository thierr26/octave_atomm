## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## caller_id} =} outman_connect_and_config_if_master_c (@var{condition}, ...)
##
## Connect to Outman if a condition is fulfilled.
##
## @code{@var{caller_id} = outman_connect_and_config_if_master_c (@var{@
## condition}, ...)} returns the Outman caller ID returned by
## @code{outman_connect_and_config_if_master (...)} if @var{condition} is true.
## Otherwise it returns -1 which is a value that is not a valid Outman caller
## ID.
##
## Please issue a @code{help outman_c} statement for examples of use of
## @code{outman_connect_and_config_if_master_c}.
##
## @seealso{outman, outman_c, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function caller_id = outman_connect_and_config_if_master_c(condition, varargin)

    validated_mandatory_args({@is_logical_scalar}, condition);

    if condition
        caller_id = outman_connect_and_config_if_master(varargin{:});
    else
        caller_id = -1;
    endif

endfunction

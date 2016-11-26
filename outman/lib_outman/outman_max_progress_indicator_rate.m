## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## max_rate} =} outman_max_progress_indicator_rate ()
##
## Maximum allowed update rate (Hz) for Outman progress indicators.
##
## @seealso{outman, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function max_rate = outman_max_progress_indicator_rate

    max_rate = 10;

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_max_progress_indicator_rate ()
##
## Return the maximum value (Hz) allowed as an update rate for a progress
## indicator.
##
## @seealso{outman, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_max_progress_indicator_rate

    ret = 10;

endfunction

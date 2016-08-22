## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_max_progress_indicator_file_rate ()
##
## Return the maximum value (Hz) allowed as an update rate for a progress
## indicator file.
##
## @seealso{outman, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = outman_max_progress_indicator_file_rate

    ret = 0.5;

endfunction

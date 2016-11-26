## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## max_rate} =} outman_max_progress_indicator_file_rate ()
##
## Maximum allowed update rate (Hz) for the Outman progress indicator file.
##
## @seealso{outman, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function max_rate = outman_max_progress_indicator_file_rate

    max_rate = 0.5;

endfunction

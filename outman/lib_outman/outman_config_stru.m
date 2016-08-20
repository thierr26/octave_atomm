## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman_config_stru ()
##
## Outman's configuration structure.
##
## Please see the documentation for @code{outman_connect_and_config_if_master}
## for more details about Outman's configuration parameters.
##
## @seealso{outman, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function stru = outman_config_stru

    hmi_cmd_win = 'command_window';
    hmi_cmd_win_no_prog = 'command_window_no_progress';

    if ispc && ~is_octave
        default_hmi_variant = hmi_cmd_win_no_prog;
    else
        default_hmi_variant = hmi_cmd_win;
    endif

    stru = struct(...
        'hmi_variant', struct(...
            'default', default_hmi_variant, ...
            'valid', @(x) is_string(x) && ismember(x, {hmi_cmd_win, ...
                hmi_cmd_win_no_prog, 'log_file_only_if_any'})), ...
        'logdir', struct(...
            'default', home_dir, ...
            'valid', @is_non_empty_string), ...
        'logname', struct(...
            'default', '', ...
            'valid', @is_string), ...
        'log_rotation_megabyte_threshold', struct(...
            'default', 10, ...
            'valid', @is_positive_integer_scalar), ...
        'log_close_ms_delay', struct(...
            'default', 3000, ...
            'valid', @is_positive_integer_scalar), ...
        'progress_format', struct(...
            'default', '[ %msg %percent%% ]', ...
            'valid', @outman_is_valid_progress_format), ...
        'progress_short_format', struct(...
            'default', '[ %percent%% ]', ...
            'valid', @outman_is_valid_progress_format), ...
        'progress_display_duration', struct(...
            'default', true, ...
            'valid', @is_logical_scalar), ...
        'progress_max_count', struct(...
            'default', 3, ...
            'valid', @is_num_scalar), ...
        'progress_update_rate', struct(...
            'default', 2, ...
            'valid', @(x) is_num_scalar(x) && x >= 0.1 ...
                && x <= outman_max_progress_indicator_rate), ...
        'progress_immediate_reshow', struct(...
            'default', is_octave, ...
            'valid', @is_logical_scalar), ...
        'info_leader', struct(...
            'default', '(I) ', ...
            'valid', @is_string), ...
        'warning_leader', struct(...
            'default', '(W) ', ...
            'valid', @is_string), ...
        'error_leader', struct(...
            'default', '(E) ', ...
            'valid', @is_string), ...
        'min_width_for_word_wrapping', struct(...
            'default', 50, ...
            'valid', @is_positive_integer_scalar));

endfunction

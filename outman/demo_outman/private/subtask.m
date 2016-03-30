## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function subtask(n, cancel, slow_func, outman_name, p_id_main)

    oId = outman_connect_and_config_if_master;
    cf = outman('get_config', oId);
    if cancel
        msg = 'Subtask';
    else
        msg = 'Subtask in progress...';
    endif
    pId = outman('init_progress', oId, 0, n, msg);
    t21 = floor(2 * n / 7);
    t22 = 2 * t21;
    if cancel
        iterCount = t22 - 1;
    else
        iterCount = n;
    endif
    for k2 = 1 : iterCount
        slow_func;
        if ~cancel && k2 == t21
            outman('dispf', oId, ['An arbitrary number of progress ' ...
                'indicators can be "stacked". If the window is not '...
                'large enough, %s switches to a very short format ' ...
                '(progress percentage only) for the progress ' ...
                'indication.\n'], outman_name);
        endif
        if k2 == t22
            outman('dispf', oId, ['At most %d are displayed (this is ' ...
                'configurable).\n'], cf.progress_max_count);
        endif
        outman('shift_progress', oId, p_id_main, 1 / 600);
        outman('update_progress', oId, pId, k2);
    endfor
    if cancel
        outman('cancel_progress', oId, pId);
    else
        outman('terminate_progress', oId, pId);
    endif
    outman('disconnect', oId);

endfunction

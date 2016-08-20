## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function stru = config_stru

    stru = outman_config_stru;

    stru.top = struct(...
        'default', pwd, ...
        'valid', @string_or_cellstr_arg_or_none);

    stru.test_case_tb_reg_exp = struct(...
        'default', '^test_', ...
        'valid', @is_non_empty_string);

    stru.test_case_reg_exp = struct(...
        'default', '^test_', ...
        'valid', @is_non_empty_string);

endfunction

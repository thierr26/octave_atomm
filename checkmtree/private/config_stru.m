## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function stru = config_stru

    default_m_file_char_set = 'ascii';

    stru = outman_config_stru;

    stru.m_file_char_set = struct(...
        'default', default_m_file_char_set, ...
        'valid', @(x) is_string(x) && ismember(x, ...
            {default_m_file_char_set, 'iso8859', 'utf8', 'win1252'}));

    stru.max_read_bytes = struct(...
        'default', 100000, ...
        'valid', @is_integer_scalar);

endfunction

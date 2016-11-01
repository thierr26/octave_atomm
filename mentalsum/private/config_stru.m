function stru = config_stru

    stru = struct(...
        'operand_digits', struct(...
            'default', 2, ...
            'valid', @(x) is_positive_integer_scalar(x) && x <= 8), ...
        'burst_count', struct(...
            'default', 4, ...
            'valid', @is_positive_integer_scalar));

end
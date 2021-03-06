function [s, default] = command_stru_and_default

    default = 'play';
    s = struct(...
        default, struct(...
            'valid', @(varargin) nargin == 0 || (nargin == 1 ...
                && is_positive_integer_scalar(varargin{1})), ...
            'no_return_value', true), ...
        'result', struct(...
            'valid', @() true, ...
            'no_return_value', false), ...
        'quit', struct(...
            'valid', @() true, ...
            'no_return_value', true));

end

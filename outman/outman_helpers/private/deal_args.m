## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function varargout = deal_args(varargin)

    if is_logical_scalar(varargin{1})
        varargout = varargin;
    else
        varargout = cell(1, nargin + 1);
        varargout{1} = true;
        varargout(2 : end) = varargin;
    endif

endfunction

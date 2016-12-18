## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function varargout = deal_args(varargin)

    if is_logical_scalar(varargin{1})
        varargout = varargin;
    else
        varargout = [true varargin];
    endif

endfunction

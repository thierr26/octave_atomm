## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} validated_mandatory_args (@var{valid_f}, ...)
##
## Validate the caller function's mandatory arguments.
##
## The first argument (@var{valid_f}) must be a row cell array of function
## handles.  The length of the array must be the number of mandatory arguments
## for the caller function.  The functions pointed to by the handles are
## hereafter called the "validation functions". They must take exactly one
## argument, return a logical scalar and behave as follows:
##
## @itemize @bullet
## @item
## Return true if the argument is valid.
##
## @item
## Return false or raise an error if the argument is not valid.
## @end itemize
##
## The arguments from the second one on are the caller function's mandatory
## arguments.
##
## @code{validated_mandatory_args} returns its arguments from the second one on
## if they are valid with regard to the validation functions.  Otherwise,
## @code{validated_mandatory_args} raises an error.
##
## Here are examples of caller functions:
##
## @example
## @group
## function example1(c, s)
##     validated_mandatory_args(@{@@iscell, @@isstruct@}, c, s);
##
##     ...
## end
## @end group
## @end example
##
## @example
## @group
## function example2(varargin)
##     if nargin ~= 2
##         error('Exactly two arguments expected');
##     end
##     [c, s] = validated_mandatory_args(...
##         @{@@iscell, @@isstruct@}, varargin@{:@});
##
##     ...
## end
## @end group
## @end example
##
## @seealso{validated_opt_args}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = validated_mandatory_args(valid_f, varargin)

    if ~is_cell_array_of_func_handle(valid_f)
        error('First argument must be a cell array of function handles');
    elseif ~same_shape(valid_f, varargin)
        error('First argument must have %d line and %d column(s)', ...
            size(varargin, 1), size(varargin, 2));
    endif

    for k = 1 : numel(varargin)
        if ~valid_f{k}(varargin{k})
            error('Argument #%d is invalid', k);
        endif
    endfor

    varargout = varargin;

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} validated_opt_args (@var{valid_f_dflt_v}, ...)
##
## Validate the caller function's optional arguments.
##
## The first argument (@var{valid_f_dflt_v}) must be a 2-dimensional cell array
## with 2 columns.  In the first column, there must be function handles.  The
## functions pointed to by the handles are hereafter called the "validation
## functions".  In the second column, there must be valid values with regard to
## the validation functions.  These values are the default values for the
## caller function's optional arguments.
##
## The validation functions must take exactly one argument, return a logical
## scalar and behave as follows:
##
## @itemize @bullet
## @item
## Return true if the argument is valid.
##
## @item
## Return false or raise an error if the argument is not valid.
## @end itemize
##
## @code{validated_opt_args} raises an error if one of the following conditions
## is fulfilled:
##
## @itemize @bullet
## @item
## The number of arguments is greater than the number of rows in
## @var{valid_f_dflt_v} plus one.
##
## @item
## The argument at position 2 (resp. 3, 4, etc.) is not valid with regard to
## the validation function pointed to by the handle in the first column of
## @var{valid_f_dflt_v} at row 1 (resp. 2, 3, etc.).
## @end itemize
##
## If no error is raised, then @code{validated_opt_args} returns as many
## output arguments as the number of rows in @var{valid_f_dflt_v}.  The 1st
## (resp. 2nd, 3rd, etc.) output argument is the input argument at position 2
## (resp. 3, 4, etc.).  If the number of input arguments is lower than the
## number of rows in @var{valid_f_dflt_v} plus one, then the trailing output
## arguments are copied from the second column of @var{valid_f_dflt_v}.
##
## Here is an example of caller function:
##
## @example
## @group
## function example1(c, s, varargin)
##     validated_mandatory_args(@{@@iscell, @@isstruct@}, c, s);
##     [str1, str2] = validated_opt_args(...
##         @{@@ischar, 'foo'; @@ischar, 'bar'@}, varargin@{:@});
##     @dots{}
## end
## @end group
## @end example
##
## @seealso{validated_mandatory_args}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = validated_opt_args(valid_f_dflt_v, varargin)

    siz = size(valid_f_dflt_v);
    nD = numel(siz);
    ok = false;
    if nD == 2 && siz(2) == 2
        valid = valid_f_dflt_v(:, 1)';
        dfltV = valid_f_dflt_v(:, 2)';
        try
            validated_mandatory_args(valid, dfltV{:});
            ok = true;
        catch
            # Nothing special to do.
        end_try_catch
    endif
    if ~ok
        error('Invalid validation functions and default values array');
    endif

    n = siz(1);
    nG = numel(varargin);
    if nG > n
        error('Too many optional arguments (%d instead of %d)', nG, n);
    endif

    varargout = cell(1, n);
    for k = 1 : n
        if nG >= k && ~valid_f_dflt_v{k, 1}(varargin{k})
            error('Optional argument #%d is invalid', k);
        elseif nG >= k
            varargout{k} = varargin{k};
        else
            varargout{k} = valid_f_dflt_v{k, 2};
        endif
    endfor

endfunction

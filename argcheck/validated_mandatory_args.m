## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {[arg1, ...] =} validated_mandatory_args (@var{@
## valid_f}, ...)
##
## Validate mandatory arguments.
##
## The intended use of function @code{validated_mandatory_args} is to validate
## the mandatory arguments of its caller function.
##
## It takes as first argument a row cell array of function handles
## (@var{valid_f}).  The length of the array must be the number of mandatory
## arguments to validate.  The functions pointed to by the handles are
## hereafter called the "validation functions".  They must take exactly one
## argument, return a logical scalar and behave as follows:
##
## @itemize @bullet
## @item
## Return true if the argument is valid.
##
## @item
## Return false or issue an error if the argument is not valid.
## @end itemize
##
## The validation functions can eventually be anonymous functions.
##
## The arguments from the second one on are the arguments to validate.
##
## Example:
##
## @example
## @group
## function example1 (@var{logical_array}, @var{numeric_array})
##
##     validated_mandatory_args (@{@@islogical, @@isnumeric@}, ...
##         @var{logical_array}, @var{numeric_array});
##
##     @dots{} % Use @var{logical_array} and @var{numeric_array} here.
## end
## @end group
## @end example
##
## If @var{logical_array} is not a logical array (as determined by function
## @code{islogical}) or @var{numeric_array} is not a numeric array (as
## determined by function @code{isnumeric}), then
## @code{validated_mandatory_args} issues an error.
##
## The next example is identical except that the output arguments of
## @code{validated_mandatory_args} are stored in the @var{l_a} and @var{n_a}
## arguments.  In this case, it is not especially useful to store the output
## arguments as they are identical to the input arguments.  It is a way of
## renaming the arguments when needed.
##
## @example
## @group
## function example2 (@var{logical_array}, @var{numeric_array})
##
##     [@var{l_a}, @var{n_a}] = validated_mandatory_args (...
##         @{@@islogical, @@isnumeric@}, ...
##         @var{logical_array}, @var{numeric_array});
##
##     @dots{} % Use @var{l_a} and @var{n_a} here.
## end
## @end group
## @end example
##
## In the case of a caller function having optional arguments, you may want to
## use function @code{validated_opt_args} also.  Please issue a
## @code{help validated_opt_args} command to read its documentation.
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

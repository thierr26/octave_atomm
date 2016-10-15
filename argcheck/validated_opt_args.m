## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {[arg1, ...] =} validated_opt_args (@var{@
## valid_f_dflt_v}, ...)
##
## Validate optional arguments.
##
## The intended use of function @code{validated_opt_args} is to validate the
## optional arguments of its caller function.
##
## It takes as first argument a 2 column cell array.  The number of rows of the
## array is the number of optional arguments.
##
## The first column of the cell array is expected to contain function handles.
## The functions pointed to by the handles are hereafter called the "validation
## functions".  They must take exactly one argument, return a logical scalar
## and behave as follows:
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
## The second column of the cell array is expected to contain the default
## values of the optional arguments.  When the @var{n}th optional argument is
## not provided, then the corresponding default value (
## @code{@var{valid_f_dflt_v}@{@var{n}, 2@}}) is used instead.  Of course it is
## required that the default values are valid values with regard to the
## validation functions:
##
## @example
## @group
## @var{valid_f_dflt_v}@{@var{n}, 1@}(@var{valid_f_dflt_v}@{@var{n}, 2@})
## @end group
## @end example
##
## returns true.
##
## The arguments from the second one on are the arguments to validate.
##
## Let's demonstrate the use of @code{validated_opt_args} with an example
## function that takes only optional arguments (in this case two optional
## arguments).
##
## @example
## @group
## function example1 (varargin)
##
##     [@var{logical_array}, @var{numeric_array}] = validated_opt_args (...
##         @{@@islogical, [true false]; ...
##          @@isnumeric, [1 2 3]@},     varargin@{:@});
##
##     @dots{} % Use @var{logical_array} and @var{numeric_array} here.
## end
## @end group
## @end example
##
## Note the use of varargin both in the function signature and the call to
## @code{validated_opt_args}.
##
## The example function above issues an error if at least one of the following
## condition is fulfilled:
##
## @itemize @bullet
## @item
## One argument is provided and it is not a logical array.
##
## @item
## Two arguments are provided and the first one is not a logical array or the
## second one is not a numeric array.
##
## @item
## More than two arguments are provided.
## @end itemize
##
## In a function that takes mandatory arguments @emph{and} optional arguments,
## you can use both @code{validated_mandatory_args} and
## @code{validated_opt_args} like in the following example.  Please issue a
## @code{help validated_mandatory_args} command to read the documentation for
## function @code{validated_mandatory_args}.
##
## @example
## @group
## function example2 (@var{char_array}, varargin)
##
##     validated_mandatory_args (@{@@ischar@}, @var{char_array});
##
##     [@var{logical_array}, @var{numeric_array}] = validated_opt_args (...
##         @{@@islogical, [true false]; ...
##          @@isnumeric, [1 2 3]@},     varargin@{:@});
##
##     @dots{} % Use @var{char_array}, @var{logical_array}
##         % and @var{numeric_array} here.
## end
## @end group
## @end example
##
## @seealso{validated_mandatory_args, varargin}
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

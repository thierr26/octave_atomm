## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} debug_diff (@var{old}, @var{new})
## @deftypefnx {Function File} debug_diff (@var{filename}, @var{old}, @var{@
## new})
## @deftypefnx {Function File} debug_diff (@var{s}, @var{old}, @var{new})
## @deftypefnx {Function File} debug_diff (@var{old})
## @deftypefnx {Function File} debug_diff (@var{filename}, @var{new})
## @deftypefnx {Function File} debug_diff (@var{s}, @var{new})
##
## Find how a variable has changed.
##
## @code{debug_diff (@var{old}, @var{new})} prints some lines of text to the
## command window, using @code{fprintf}.  The text explicits the difference
## between variables @var{old} and @var{new}.
##
## @code{debug_diff (@var{filename}, @var{old}, @var{new})} does the same but
## appends to the file @var{filename} instead of the command window.  Note that
## the file name can also be passed via a structure having a field "debug_log".
## Please see the documentation for @code{debug_msg} for more details.
##
## Instead of passing both @var{old} and @var{new} at the same time, the user
## can pass @var{old} at some point and pass @var{new} later to find how it has
## changed.  IMPORTANT: Make sure that no other call to @code{debug_diff} is
## issued between the call with @var{old} and the call with @var{new},
## otherwise you not get what you expect.
##
## @code{debug_diff} does not handle all possible cases, far from it.  When it
## cannot handle a case, the output text states it.  It will be updated as
## needed.
##
## @seealso{debug_msg, fprintf}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function debug_diff(varargin)

    persistent persistentSet v;

    f = '';
    if isempty(persistentSet)
        if nargin == 3
            validated_mandatory_args({@(x) is_string(x) || isstruct(x)}, ...
                varargin{1});
            f = varargin{1};
            old = varargin{2};
            new = varargin{3};
        elseif nargin == 2
            f = 1;
            old = varargin{1};
            new = varargin{2};
        else
            validated_mandatory_args({@(x) true}, varargin{:});
            v = varargin{1};
            persistentSet = true;
        endif
    else
        old = v;
        if nargin == 2
            validated_mandatory_args({@(x) is_string(x) || isstruct(x)}, ...
                varargin{1});
            f = varargin{1};
            new = varargin{2};
        else
            validated_mandatory_args({@(x) true}, varargin{:});
            f = 1;
            new = varargin{1};
        endif
        persistentSet = false;
    endif

    if ~isempty(f)
        explicit_diff(f, old, new);
    endif

    if isempty(persistentSet) || ~persistentSet
        munlock;
        clear(mfilename);
    else
        mlock;
    endif

endfunction

# -----------------------------------------------------------------------------

# Explicit the difference between old and new.

function explicit_diff(f, old, new)

    cla1 = class(old);
    cla2 = class(new);
    if strcmp(cla1, cla2)

        if is_string(new) && ~strcmp(old, new)
            debug_msg_str_change(f, old, new);
        elseif isnumeric(new) && isvector(new) ...
                && (isempty(old) || isvector(old)) ...
                && numel(new) == numel(old) + 1;
            debug_msg_vec_1_more(f, old, new);
        elseif isnumeric(old) && isvector(old) ...
                && (isempty(new) || isvector(new)) ...
                && numel(old) == numel(new) + 1;
            debug_msg_vec_1_less(f, old, new);
        elseif isstruct(new) && isstruct(old)
            fi = unique([fieldnames(new); fieldnames(old)]);
            isAddedF = cellfun(@(x) isfield(new, x) && ~isfield(old, x), fi);
            isLostF = cellfun(@(x) isfield(old, x) && ~isfield(new, x), fi);
            if any(isLostF)
                debug_msg(f, 'Structure has lost the following field(s)');
            endif
            for k = 1 : numel(fi)
                if isLostF(k)
                    debug_msg(f, '\t%s', fi{k});
                endif
            endfor
            if any(isAddedF)
                debug_msg(f, 'Structure has gained the following field(s)');
            endif
            for k = 1 : numel(fi)
                if isAddedF(k)
                    debug_msg(f, '\t%s:', fi{k});
                    debug_disp(f, new.(fi{k}));
                endif
            endfor
            n = 0;
            for k = 1 : numel(fi)
                if ~isAddedF(k) && ~isLostF(k) ...
                        && ~isequal(old.(fi{k}), new.(fi{k}))
                    n = n + 1;
                    if n == 1
                        debug_msg(f, 'The following field(s) have changed:');
                    endif
                    debug_msg(f, '\t%s:', fi{k});
                    # recursive call.
                    explicit_diff(f, old.(fi{k}), new.(fi{k}));
                endif
            endfor
        elseif ~isequal(old, new)
            debug_msg(f, ['Unable to explicit the difference. You may ' ...
                'want to update %s'], mfilename);
        endif

    else
        debug_msg(f, 'Class has changed: %s -> %s', cla1, cla2);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Explicit a string value change.

function debug_msg_str_change(f, old, new)

    debug_msg(f, 'String value has changed:');
    debug_msg(f, '%s', old);
    debug_msg(f, '%s', new);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Explicit a one component growth for a numerical vector.

function debug_msg_vec_1_more(f, old, new)

    if isrow(new) && (isempty(old) || isrow(old))
        if isequal(new(1 : end - 1), old)
            debug_msg(f, ['Row vector has now one more component (%d ' ...
                'component(s)): %g'], numel(new), new(end));
        else
            debug_msg(f, ['Row vector has now one more component (%d ' ...
                'component(s)) but other values have changed as well'], ...
                numel(new));
        endif
    elseif iscolumn(new) && (isempty(old) || iscolumn(old))
        if isequal(new(1 : end - 1), old)
            debug_msg(f, ['Column vector has now one more component (%d ' ...
                'component(s)): %g'], numel(new), new(end));
        else
            debug_msg(f, ['Column vector has now one more component (%d ' ...
                'component(s)) but other values have changed as well'], ...
                numel(new));
        endif
    elseif isrow(new)
        debug_msg(f, ['Vector has now one more component (%d ' ...
            'component(s)) and is now a row vector instead of a column ' ...
            'vector'], numel(new));
    elseif iscolumn(new)
        debug_msg(f, ['Vector has now one more component (%d ' ...
            'component(s)) and is now a column vector instead of a row ' ...
            'vector'], numel(new));
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Explicit a one component loss for a numerical vector.

function debug_msg_vec_1_less(f, old, new)

    if isrow(old) && (isempty(new) || isrow(new))
        if isequal(old(1 : end - 1), new)
            debug_msg(f, ['Row vector has now one less component (%d ' ...
                'component(s))'], numel(new));
        else
            debug_msg(f, ['Row vector has now one less component (%d ' ...
                'component(s)) but other values have changed as well'], ...
                numel(new));
        endif
    elseif iscolumn(old) && (isempty(new) || iscolumn(new))
        if isequal(old(1 : end - 1), new)
            debug_msg(f, ['Column vector has now one less component (%d ' ...
                'component(s))'], numel(new));
        else
            debug_msg(f, ['Column vector has now one less component (%d ' ...
                'component(s)) but other values have changed as well'], ...
                numel(new));
        endif
    elseif isrow(old)
        debug_msg(f, ['Vector has now one less component (%d ' ...
            'component(s)) and is now a row vector instead of a column ' ...
            'vector'], numel(new));
    elseif iscolumn(old)
        debug_msg(f, ['Vector has now one less component (%d ' ...
            'component(s)) and is now a column vector instead of a row ' ...
            'vector'], numel(new));
    endif

endfunction

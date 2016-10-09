## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{abs_path} =} absolute_path (@var{path})
## @deftypefnx {Function File} {@var{abs_path} =} absolute_path (@var{@
## find_files_s}, @var{k})
## @deftypefnx {Function File} {@var{abs_path} =} absolute_path (@var{@
## find_files_s}, @var{k}, @var{no_check})
##
## Return a full file path.
##
## Function @code{absolute_path} can be used in two different ways:
##
## @enumerate
## @item As a path expanding function.
##
## When provided with a path string (relative or absolute) as argument,
## @code{absolute_path} returns the absolute path.
##
## @item As an absolute file path extractor for @code{find_files} structures.
##
## When provided with a @code{find_files} structure and a file index,
## @code{absolute_path} returns the absolute path to the corresponding file.
## This use of @code{absolute_path} is presented in the documentation for
## @code{find_files}.  Please run @code{help find_files} to read it.
##
## @code{absolute_path} performs by default a check of the input structure.  If
## you know that your input is safe (e.g.@ if is the input is a direct output
## of @code{find_files}), you can instruct @code{absolute_path} to skip the
## check by providing a supplementary argument (a logical flag).  A true value
## for this supplementary argument causes @code{absolute_path} to skip the
## check.
## @end enumerate
##
## @seealso{find_files}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = absolute_path(s, varargin)

    validated_mandatory_args({@(x) isstruct(x) || is_non_empty_string(x)}, s);

    if isstruct(s)
        [~, nocheck] = validated_opt_args(...
            {@is_positive_integer_scalar, 1; ...
            @is_logical_scalar, false}, varargin{:});
        if ~nocheck
            if nargin < 2
                error(['When the first argument is a structure output by ' ...
                    'find_files, a scalar file index is required as ' ...
                    'second argument']);
            endif
            validated_mandatory_args({@is_find_files_s}, s);
            if varargin{1} > numel(s.dir_idx)
                error('Index out of range');
            endif
        endif
        ret = fullfile(s.dir{s.dir_idx(varargin{1})}, s.file{varargin{1}});
    else
        if nargin > 1
            error(['When the first argument is a string, no other ' ...
                'arguments are allowed']);
        endif
        ret = absolute_path_from_scratch(s);
    endif

endfunction

# -----------------------------------------------------------------------------

# Return true for an absolute file path.

function ret = is_absolute(s)

    if ispc
        # The system is a Windows system.

        driveDesignatorRegExp = '^[A-Za-z]:';
        if is_matched_by(s, [driveDesignatorRegExp '[^\' filesep ']'])
            error('Per drive relative directories not supported');
        elseif is_matched_by(s, [driveDesignatorRegExp '$'])
            error('Per drive current directories not supported');
        else
            ret = is_matched_by(s, [driveDesignatorRegExp '\' filesep]);
        endif
    else
        # The system is not a Windows system.

        ret = strncmp(s, filesep, length(filesep));
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Remove trailing file separator if any and return the indices of the remaining
# file separators.

function [s, sep_pos] = remove_trailing_sep(s1)

    sep_pos = strfind(s1, filesep);
    if numel(sep_pos) > 1 && is_matched_by(s1, ['\' filesep '$'])
        # There is a trailing file separator.

        # Remove the trailing file separator.
        s = s1(1 : end - length(filesep));
        sep_pos = sep_pos(1 : end - 1);
    else
        s = s1;
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return the absolute file path from a relative or absolute file path.

function ret = absolute_path_from_scratch(s)

    if is_absolute(s)
        # The argument is an absolute path.

        a = s;
    else
        # The argument is not an absolute path.

        a = fullfile(pwd, s);
    endif

    [a, sepPos] = remove_trailing_sep(a);

    while numel(sepPos) > 1 && min(diff(sepPos)) == 1
        # There is at least one double file separator in a.

        # Substitute the first double file separator with a single one.
        a = regexprep(a, ['\' filesep '\' filesep], filesep);
        sepPos = strfind(a, filesep);
    endwhile

    # Interpret and substitute the occurrences of "." and "..".
    aLen = length(a);
    keep = true(1, aLen);
    endFS1 = sepPos(1) + length(filesep) - 1;
    if aLen > endFS1
        k = endFS1;
        while k < aLen
            kk = min([aLen sepPos(find(sepPos > k, 1)) - 1]);
            dir = a(k + 1 : kk);
            if strcmp(dir, '.')
                keep(k : kk) = false;
            elseif strcmp(dir, '..')
                if k > endFS1
                    keep(sepPos(find(sepPos < k, 1, 'last')) : kk) = false;
                else
                    error('Inappropriate usage of ".."');
                endif
            endif
            k = kk + 1;
        endwhile
        ret = a(keep);
    else
        ret = a;
    endif

endfunction

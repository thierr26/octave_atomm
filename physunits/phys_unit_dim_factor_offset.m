## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{dim}, @var{f}, @var{@
## o}] =} phys_unit_dim_factor_offset (@var{s}, @var{unit})
##
## Dimension, factor and offset for a physical unit.
##
## You probably don't have to use this function directly.  Use
## @code{is_known_phys_unit} to check that a unit is "supported" and
## @code{phys_units_conv} to perform physical units conversions.
##
## @code{[@var{dim}, @var{f}, @var{o}] = phys_unit_dim_factor_offset (@var{s},
## @var{unit})} returns the kind of information that are in the field
## @qcode{"other_units"} of a physical units system structure (see
## documentation for @code{phys_units_system} for more details).  @var{s} is a
## physical units system structure.  @var{unit} is a unit symbol (e.g.@ "m",
## "s", "m/s", "m / s", "m/s/s", "m/s2", "m.s-2").  Empty unit symbols are
## allowed.
##
## @itemize @bullet
## @item
## @var{dim}: Dimension for unit @var{unit};
##
## @item
## @var{f}: Factor for unit @var{unit};
##
## @item
## @var{o}: Offset for unit @var{unit}.
## @end itemize
##
## No argument checking is done on @var{s}.
##
## @seealso{is_known_phys_unit, phys_units_conv, phys_units_system}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function [dim, f, o] = phys_unit_dim_factor_offset(s, unit)

    validated_mandatory_args({@check_stru, @is_string}, s, unit);

    baseUnitsNoPrefix = s.base_units;
    if isequal(s.base_units, base_phys_units)
        # Handle the special case of "kg" (base unit with a prefix).
        assert(strcmp(s.base_units{2}, 'kg'));
        [pI, pL] = prefix_idx(s, s.base_units{2});
        assert(pI > 0);
        baseUnitsNoPrefix{2} = s.base_units{2}(pL + 1 : end);
    endif

    dim = zeros(1, numel(s.base_units));
    f = 1;
    o = 0;
    if ~is_blank_string(unit)

        [iu, ex] = parse(s, baseUnitsNoPrefix, unit);
        [iu, f, baseIdx, otherIdx] ...
            = factorize_prefixes(s, baseUnitsNoPrefix, iu, ex);
        nonZeroOffset = isscalar(iu) && otherIdx > 0 && f == 1 ...
            && isscalar(find(s.other_units{otherIdx, 2})) ...
            && s.other_units{otherIdx, 4} ~= 0;
        if nonZeroOffset
            dim = s.other_units{otherIdx, 2};
            f = s.other_units{otherIdx, 3};
            o = s.other_units{otherIdx, 4};
        else
            [ex, f, baseIdx] = to_base(s, ex, f, baseIdx, otherIdx);
            dim(baseIdx) = ex;
        endif
    endif

endfunction

# -----------------------------------------------------------------------------

# Check the physical units system structure.

function ret = check_stru(s)

    ret = is_valid_phys_unit_prefix_list(s.prefix_list);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Issue an "invalid unit symbol error" if cond is false.

function assert_valid_unit_symbol(cond, unit)

    assert(cond, 'Invalid unit symbol: %s', unit);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# True for a unit symbol (with or without prefix) which is a known unit symbol.

function ret = is_known(s, b_u_no_pref, u)

    ret = ismember(u, s.base_units) ...
        || ismember(u, b_u_no_pref) ...
        || ismember(u, s.other_units(:, 1));
    if ~ret
        [pI, pL] = prefix_idx(s, u);
        if pI > 0
            ret = ismember(u(pL + 1 : end), b_u_no_pref) ...
                || ismember(u(pL + 1 : end), s.other_units(:, 1));
        endif
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Parse the unit symbol.
# iu: A cell array with individual unit symbols.
# ex: A numerical array with exponents.

function [iu, ex] = parse(s, b_u_no_pref, unit)

    mul = '.';
    div = '/';

    u = strtrim(unit);
    spacePos = strfind(u, ' ');
    for k = spacePos
        if u(k - 1) ~= mul && u(k - 1) ~= div ...
                && u(k + 1) ~= mul && u(k + 1) ~= div
            u(k) = mul;
        endif
    endfor
    spacePos = strfind(u, ' ');
    u(spacePos) = [];

    sepPos = sort([strfind(u, mul) strfind(u, div)]);

    n = numel(sepPos) + 1;
    iu = cell(1, n);
    ex = ones(1, n);
    isKnown = false(1, n);

    k = 0;
    mustAddDot = false;
    while ~mustAddDot && k < n

        k = k + 1;

        if k == 1
            start = 1;
        else
            start = sepPos(k - 1) + 1;
        endif
        if k == n
            finish = length(u);
        else
            finish = sepPos(k) - 1;
        endif
        assert_valid_unit_symbol(finish >= start, unit);
        assert_valid_unit_symbol(~is_matched_by(u(start), '[0-9-]'), unit);

        minusMatch = regexp(u(start : finish), '-');
        assert_valid_unit_symbol(numel(minusMatch) <= 1, unit);
        hasMinus = isscalar(minusMatch);

        digitMatch = regexp(u(start : finish), '[0-9]');
        hasDigit = ~isempty(digitMatch);
        assert_valid_unit_symbol(~hasMinus || hasDigit, unit);
        assert_valid_unit_symbol(...
            ~hasDigit || digitMatch(end) == finish - start + 1, unit);
        assert_valid_unit_symbol(...
            numel(digitMatch) <= 1 || max(diff(digitMatch)) == 1, unit);
        assert_valid_unit_symbol(...
            ~hasMinus || minusMatch == digitMatch(1) - 1, unit);

        if hasDigit
            ex(k) = str2double(u(digitMatch + start - 1));
            if hasMinus
                ex(k) = -ex(k);
                iu{k} = u(start : minusMatch + start - 2);
            else
                iu{k} = u(start : digitMatch(1) + start - 2);
            endif
        else
            iu{k} = u(start : finish);
        endif
        if k > 1 && strcmp(u(sepPos(k - 1)), div)
            ex(k) = -ex(k);
        endif

        if ~is_known(s, b_u_no_pref, iu{k})
            dotPos = 2;
            while dotPos <= length(iu{k}) ...
                    && (~is_known(s, b_u_no_pref, iu{k}(1 : dotPos - 1)) ...
                    || ~is_known(s, b_u_no_pref, iu{k}(dotPos : end)));
                dotPos = dotPos + 1;
            endwhile
            if is_known(s, b_u_no_pref, iu{k}(1 : dotPos - 1)) ...
                    && is_known(s, b_u_no_pref, iu{k}(dotPos : end))
                mustAddDot = true;
            endif
        else
            isKnown(k) = true;
        endif

    endwhile

    if mustAddDot
        [iu, ex] = parse(s, b_u_no_pref, ...
            strrep(u, iu{k}, [iu{k}(1 : dotPos - 1) ...
            '.' iu{k}(dotPos : end)])); % Recursive call.
    else
        assert_valid_unit_symbol(all(isKnown), unit);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return in idx the index in s.prefix_list of the prefix in unit_symbol or 0 if
# no prefix is used in unit_symbol. len is the length of the prefix.

function [idx, len] = prefix_idx(s, unit_symbol)

    idx = 0;
    if isempty(s.prefix_list)
        match = [];
    else
        match = cellfun(...
            @(x) strncmp(x, unit_symbol, length(x)) ...
                && length(unit_symbol) > length(x), ...
            s.prefix_list(:, 1));
    endif
    len = 0;
    for k = find(match)'
        l = length(s.prefix_list{k, 1});
        if l > len
            len = l;
            idx = k;
        endif
    endfor

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Factorize the prefixes.
# iu: A cell array iu with individual unit symbols (with prefixes removed).
# f: Global factor implied by the prefixes.
# base_idx: Array (same shape as iu) of indices to s.base_units (zero for
# components corresponding to non base units).
# other_idx: Array (same shape as iu) of indices to s.other_units(:, 1) (zero
# for components corresponding to base units).

function [iu, f, base_idx, other_idx] ...
        = factorize_prefixes(s, b_u_no_pref, iu1, ex)

    iu = iu1;
    f = 1;
    n = numel(iu);
    base_idx = zeros(1, n);
    other_idx = zeros(1, n);
    for k = 1 : n
        [flag, idx] = ismember(iu{k}, s.base_units);
        if flag
            base_idx(k) = idx;
        endif;
        if ~flag
            [flag, idx] = ismember(iu{k}, b_u_no_pref);
            if flag
                base_idx(k) = idx;
                f = prod_exact_for_10_pow(f, 1 / ...
                    phys_unit_prefixes(s.prefix_list, ...
                    s.base_units{idx}(1 : ...
                    length(s.base_units{idx}) ...
                    - length(b_u_no_pref{idx}))) ^ ex(k));
            endif
        endif
        if ~flag
            [flag, idx] = ismember(iu{k}, s.other_units(:, 1));
            if flag
                other_idx(k) = idx;
            endif;
        endif
        if ~flag
            [pI, pL] = prefix_idx(s, iu{k});
        endif
        if ~flag
            [flag, idx] = ismember(iu{k}(pL + 1 : end), s.base_units);
            if flag
                base_idx(k) = idx;
                f = prod_exact_for_10_pow(f, s.prefix_list{pI, 2} ^ ex(k));
            endif
        endif
        if ~flag
            [flag, idx] = ismember(iu{k}(pL + 1 : end), b_u_no_pref);
            if flag
                base_idx(k) = idx;
                f = prod_exact_for_10_pow(f, 1 / ...
                    phys_unit_prefixes(s.prefix_list, ...
                    s.base_units{idx}(1 : ...
                    length(s.base_units{idx}) ...
                    - length(b_u_no_pref{idx}))) ^ ex(k));
                f = prod_exact_for_10_pow(f, s.prefix_list{pI, 2} ^ ex(k));
            endif
        endif
        if ~flag
            [flag, idx] = ismember(iu{k}(pL + 1 : end), s.other_units(:, 1));
            if flag
                other_idx(k) = idx;
                f = prod_exact_for_10_pow(f, s.prefix_list{pI, 2} ^ ex(k));
            endif
        endif
    endfor

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Convert non base units to base units.

function [ex, f, base_idx] = to_base(s, ex1, f1, base_idx1, other_idx)

    n1 = numel(ex1);
    nMax = n1 * numel(s.base_units);
    ex = zeros(1, nMax);
    base_idx = zeros(1, nMax);
    f = f1;

    kk = 0;
    for k = 1 : n1
        kk = kk + 1;
        if base_idx1(k)
            n = 1;
            ex(kk) = ex1(k);
            base_idx(kk) = base_idx1(k);
        else
            idx = find(s.other_units{other_idx(k), 2});
            n = numel(idx);
            ex(kk : kk + n - 1) ...
                = s.other_units{other_idx(k), 2}(idx) .* ex1(k);
            base_idx(kk : kk + n - 1) = idx;
            f = prod_exact_for_10_pow(f, ...
                s.other_units{other_idx(k), 3} ^ ex1(k));
        endif
        kk = kk + n - 1;
    endfor

    n = kk;
    ex = ex(1 : n);
    base_idx = base_idx(1 : n);

    uniqIdx = unique(base_idx);
    n = numel(uniqIdx);
    for k = 1 : n
        idx = find(base_idx == uniqIdx(k));
        firstIdx = idx(1);
        if ~isscalar(idx)
            ex(firstIdx) = sum(ex(idx));
            ex(idx(2 : end)) = [];
            base_idx(idx(2 : end)) = [];
        endif
    endfor

endfunction

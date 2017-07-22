## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{c} =} phys_unit_prefixes ()
## @deftypefnx {Function File} {@var{factor} =} phys_unit_prefixes (@var{pref})
## @deftypefnx {Function File} {@
## @var{c} =} phys_unit_prefixes (@var{prefix_list})
## @deftypefnx {Function File} {@
## @var{factor} =} phys_unit_prefixes (@var{prefix_list}, @var{pref})
##
## Unit prefixes list and associated factors.
##
## The primary functionality of @code{phys_unit_prefixes} is to return the
## factor associated with a physical unit prefix.  The physical unit prefix
## must be provided as an argument:
##
## @example
## @group
## phys_unit_prefixes ("da")
##    @result{} 10
##
## phys_unit_prefixes ("m")
##    @result{} 0.001
## @end group
## @end example
##
## The supported prefixes are defined in the default prefix list.  This default
## list is returned by a call to @code{phys_unit_prefixes} without input
## argument.  It is returned as a 2 column cell array.  It is exactly the kind
## of cell arrays used in the @qcode{"prefix_list"} of a physical units system
## structure.  Please see the documentation for @code{phys_units_system}.
##
## @example
## @group
## phys_unit_prefixes ()
## @end group
## @end example
##
## The default prefix list is the list of the standard prefixes for the
## International System of Units @emph{with prefix micro omitted} because there
## is no universal convention for the symbol of this prefix.
##
## If the default prefix list is not suitable for your application, you can
## provide a specific prefix list as first argument to
## @code{phys_unit_prefixes}.
##
## One of the following functions may provide a prefix list suitable for your
## application.  The prefix list they provide is the default prefix list with
## the micro prefix added with a particular symbol.
##
## @itemize @bullet
## @item
## @code{phys_unit_prefix_list_micro_extended_ascii_181};
##
## @item
## @code{phys_unit_prefix_list_micro_u03bc};
##
## @item
## @code{phys_unit_prefix_list_micro_u};
##
## @item
## @code{phys_unit_prefix_list_micro_mc};
## @end itemize
##
## Here are a few examples:
##
## @example
## @group
## phys_unit_prefixes (phys_unit_prefix_list_micro_u (), 'u')
##    @result{} 0.000001
##
## phys_unit_prefixes (phys_unit_prefix_list_micro_u (), 'da')
##    @result{} 10
##
## phys_unit_prefixes (phys_unit_prefix_list_micro_mc (), 'mc')
##    @result{} 0.000001
##
## phys_unit_prefixes (phys_unit_prefix_list_micro_mc (), 'da')
##    @result{} 10
## @end group
## @end example
##
## @seealso{is_valid_phys_unit_prefix_list,
## phys_unit_prefix_list_micro_extended_ascii_181,
## phys_unit_prefix_list_micro_mc,
## phys_unit_prefix_list_micro_mc, phys_unit_prefix_list_micro_u03bc}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = phys_unit_prefixes(varargin)

    persistent defaultPrefixList;

    if isempty(defaultPrefixList)
        defaultPrefixList = {...
            'da', 1e1; ...
            'h', 1e2; ...
            'k', 1e3; ...
            'M', 1e6; ...
            'G', 1e9; ...
            'T', 1e12; ...
            'P', 1e15; ...
            'E', 1e18; ...
            'Z', 1e21; ...
            'Y', 1e24; ...
            'd', 1e-1; ...
            'c', 1e-2; ...
            'm', 1e-3; ...
            'n', 1e-9; ...
            'p', 1e-12; ...
            'f', 1e-15; ...
            'a', 1e-18; ...
            'z', 1e-21; ...
            'y', 1e-24};
    endif

    customListProvided = nargin >= 1 && iscell(varargin{1});
    prefArgPos = double(customListProvided) + 1;
    prefProvided = nargin >= prefArgPos;

    if ~customListProvided && ~prefProvided
        ret = defaultPrefixList;
    elseif ~customListProvided && prefProvided
        validated_mandatory_args({@is_string}, varargin{:});
        [supportedPref, idx] = ismember(varargin{prefArgPos}, ...
            defaultPrefixList(:, 1));
        assert_supported_pref(supportedPref, varargin{prefArgPos});
        ret = defaultPrefixList{idx, 2};
    elseif customListProvided && ~prefProvided
        ret = validated_mandatory_args({@is_valid_phys_unit_prefix_list}, ...
            varargin{:});
    else
        validated_mandatory_args(...
            {@is_valid_phys_unit_prefix_list, @is_string}, varargin{:});
        supportedPref = ~isempty(varargin{1});
        if supportedPref
            [supportedPref, idx] ...
                = ismember(varargin{prefArgPos}, varargin{1}(:, 1));
        endif
        assert_supported_pref(supportedPref, varargin{prefArgPos});
        ret = varargin{1}{idx, 2};
    endif

endfunction

# -----------------------------------------------------------------------------

# Assert the flag argument.

function assert_supported_pref(flag, pref)

    assert(flag, 'Prefix "%s" not found in prefix list', pref);

endfunction

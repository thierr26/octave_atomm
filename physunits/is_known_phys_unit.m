## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_known_phys_unit (@var{@
## s}, @var{unit})
## @deftypefnx {Function File} {@var{ret} =} is_known_phys_unit (@var{unit})
##
## True for a "supported" unit symbol.
##
## @code{@var{ret} = is_known_phys_unit (@var{s}, @var{unit})} returns true if
## the physical unit symbol @var{unit} is "supported" by physical units system
## @var{s}.  If argument @var{s} is not provided, then the output of
## @code{common_phys_units_system} is used instead.  See documentation for
## @code{phys_units_system} for more details about physical units system
## structures.
##
## Note that empty or blank strings (e.g.@ @code{''}, @code{' '}) are valid
## unit symbols.
##
## @seealso{common_phys_units_system, phys_units_conv, phys_units_system}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_known_phys_unit(varargin)

    s = check_args_and_set_stru(varargin{:});
    try
        phys_unit_dim_factor_offset(s, varargin{end});
        ret = true;
    catch
        ret = false;
    end_try_catch

endfunction

# -----------------------------------------------------------------------------

# Check the arguments and return the physical units system structure.

function s = check_args_and_set_stru(varargin)

    assert(nargin > 0, 'At least one argument expected');
    if isstruct(varargin{1})
        s = varargin{1};
        assert_correct_nargin(2, varargin{:});
    else
        s = common_phys_units_system;
        assert_correct_nargin(1, varargin{:});
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check the argument number.

function assert_correct_nargin(expected_nargin, varargin)

    assert(nargin - 1 == expected_nargin, ['One or two arguments ' ...
        'expected. If two arguments are provided, then the first one must ' ...
        'be a physical units system structure. The last one must always ' ...
        'be a physical unit symbol.']);

endfunction

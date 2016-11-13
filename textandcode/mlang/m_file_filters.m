## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{filter} =} m_file_filters ()
## @deftypefnx {Function File} {@var{filter} =} m_file_filters ('all')
## @deftypefnx {Function File} {@var{filter} =} m_file_filters ('m_lang_only')
##
## File filters (like "*.m") for Matlab or Octave function files.
##
## @code{@var{filter} = m_file_filters ()} returns a cell array of strings
## in @var{filter} containing the various file filters for function files.
##
## If this is Octave running the function, the returned cell array contains:
##
## @itemize @bullet
## @item "*.m"
##
## @item "*.mex" (more precisely @code{['*.' mexext]})
##
## @item "*.oct"
## @end itemize
##
## If this is Matlab running the function, the returned cell array contains:
##
## @itemize @bullet
## @item "*.m"
##
## @item @code{['*.' mexext]} (this expression evaluates to multiple values,
## depending on the platform)
## @end itemize
##
## @code{@var{filter} = m_file_filters ('all')} is equivalent to
## @code{@var{filter} = m_file_filters ()}
##
## @code{@var{filter} = m_file_filters('m_lang_only')} returns a cell array
## containing only "*.m".
##
## @seealso{mexext, pcode}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function filter = m_file_filters(varargin)

    str = validated_opt_args({@is_valid_arg, 'all'}, varargin{:});

    filter = {'*.m'};
    if strcmp(str, 'all')
        if is_octave
            filter(end + 1 : end + 2) = {['*.' mexext], '*.oct'};
        else
            filter(end + 1 : end + 2) = {'*.p', ['*.' mexext]};
        endif
    endif

endfunction

# -----------------------------------------------------------------------------

# Check argument validity.

function ret = is_valid_arg(str)

    ret = is_string(str) && (any(strcmp(str, {'all', 'm_lang_only'})));

endfunction

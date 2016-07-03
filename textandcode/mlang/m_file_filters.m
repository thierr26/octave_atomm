## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} m_file_filters ()
## @deftypefnx {Function File} m_file_filters ('all')
## @deftypefnx {Function File} m_file_filters ('m_lang_only')
##
## File filters (like "*.m") for Matlab / Octave function files.
##
## @code{m_file_filters} and @code{m_file_filters('all')} are equivalent.  Both
## return a cell array containing "*.m" and "*.p" if this is Matlab running the
## function or a cell array containing only "*.m" if this is Octave running the
## function.
##
## @code{m_file_filters('m_lang_only')} returns a cell array containing only
## "*.m".
##
## @seealso{pcode}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = m_file_filters(varargin)

    str = validated_opt_args({@is_valid_arg, 'all'}, varargin{:});

    if ~is_octave && strcmp(str, 'all')
        ret = {'*.m', '*.p'};
    else
        ret = {'*.m'};
    endif

endfunction

# -----------------------------------------------------------------------------

# Check argument validity.

function ret = is_valid_arg(str)

    ret = is_string(str) && (any(strcmp(str, {'all', 'm_lang_only'})));

endfunction

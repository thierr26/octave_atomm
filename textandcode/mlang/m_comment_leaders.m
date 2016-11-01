## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{str} =} m_comment_leaders ()
##
## String containing the allowed comment leaders for the Octave language.
##
## @code{@var{str} = m_comment_leaders ()} returns string "%#" in @var{str}.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function str = m_comment_leaders

    str = '%#';

endfunction

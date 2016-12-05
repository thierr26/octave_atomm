## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} atomm_dir ()
## @deftypefnx {Function File} {@var{ret} =} atomm_dir (@var{dir})
##
## Atomm installation directory.
##
## @code{@var{ret} = atomm_dir ()} returns the installation directory for Atomm
## in @var{ret} (i.e.@ the parent directory of the directory containing
## function @code{atomm_dir}).
##
## @code{@var{ret} = atomm_dir (@var{dir})} returns @var{dir} on the first call
## and returns the same value on subsequent calls.  Using a
## @code{@var{ret} = atomm_dir (@var{dir})} statement instead of a
## @code{@var{ret} = atomm_dir ()} is useful when the installation directory
## for Atomm has already been stored in @var{dir} and the programmer wants to
## avoid that @code{atomm_dir} computes the value again which would be a waste
## of time.
##
## No argument checking is done.
##
## Implementation note: @code{atomm_dir} stores the return value of the first
## call in a persistent variable.  This (hopefully) makes the subsequent calls
## faster.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = atomm_dir(varargin)

    persistent d;

    if isempty(d)
        if nargin == 0
            d = fileparts(fileparts(mfilename('fullpath')));
        else
            d = varargin{1};
        end
    end

    ret = d;

endfunction

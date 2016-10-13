## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{stru} =} find_files_empty_s ()
##
## Initialize an empty @code{find_files} return structure.
##
## @code{@var{stru} = find_files_empty_s ()} returns a structure that can be
## used as first argument to function @code{find_files}.  The fields of the
## structure are empty.  Such a structure is useful when using
## @code{find_files} iteratively.  Please see the documentation for
## @code{find_files} (run @code{help find_files}) for details and examples.
##
## @seealso{find_files}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = find_files_empty_s

    s = struct();
        s(1).dir = {};
        s.first_file_idx = [];
        s.last_file_idx = [];
        s.file = {};
        s.dir_idx = [];
        s.bytes = [];
        s.datenum = [];

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} find_files_empty_s ()
##
## Return a structure that can be used as first argument to @code{find_files}.
##
## @code{find_files_empty_s} returns a structure that has all the needed fields
## to be a valid first argument to @code{find_files}.  The fields in the
## structure are empty.
##
## @code{find_files_empty_s} is usefull as an initial argument to
## @code{find_files} in loops like in this example:
##
## @example
## @group
## f = @{'*.m', '*.c'@};
## s = find_files_empty_s;
## for k = 1 : numel(f)
##     s = find_files(s, pwd, f@{k@});
## end
## @end group
## @end example
##
## If @code{find_files_empty_s} did not exist, this should be done instead:
##
## @example
## @group
## f = @{'*.m', '*.c'@};
## for k = 1 : numel(f)
##     if k == 1
##         s = find_files(pwd, f@{k@});
##     else
##         s = find_files(s, pwd, f@{k@});
##     end
## end
## @end group
## @end example
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

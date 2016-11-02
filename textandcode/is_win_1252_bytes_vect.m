## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_win_1252_bytes_vect (@var{@
## v}, @var{siz})
##
## True for a vector of Windows-1252 character byte codes.
##
## @code{is_win_1252_bytes_vect} is intended to be used to check whether the
## byte values read from a file are Windows-1252 codes or not.  Example:
##
## @example
## @group
## @var{fileName} = "path/to/the/file";
## @var{siz} = file_byte_size (@var{fileName});
## @var{f} = fopen (@var{fileName}, 'r');
## @var{v} = fread (@var{f}, 1000, '*uint8'); % Read 1000 bytes from the file.
##                                % Use 'fread(@var{f}, '*uint8');' to
##                                % read the whole file.
## fclose (@var{f});
## @var{isWin1252File} = is_win_1252_bytes_vect (@var{v}, @var{siz});
## @end group
## @end example
##
## Note that function @code{file_byte_size} is available in the "fsys" toolbox
## in the Atomm source tree.
##
## Of course, you might use @code{is_win_1252_bytes_vect} on a vector that has
## not been read from a file using a statement like
## @code{is_win_1252_bytes_vect (@var{v}, numel(@var{v}))};
##
## In any case, @var{v} must be a column vector of values of type uint8.
##
## @code{is_win_1252_bytes_vect (@var{v})} returns true if the following
## conditions are fulfilled:
##
## @itemize @bullet
## @item
## The bytes all have value 9 (tabulation), 10 (line feed), 13 (carriage
## return), 128 or 142, or a value in one of the [32, 126], [130, 140],
## [145, 156] and [158, 255] ranges.
##
## @item
## Value 13, if present, always precedes value 10.
## @end itemize
##
## Note that @code{is_win_1252_bytes_vect} can be used as second argument to
## function @code{is_ascii_file}.
##
## @seealso{fclose, file_byte_size, fopen, fread, is_ascii_file,
## is_ascii_bytes_vect, is_iso_8859_bytes_vect, is_utf8_bytes_vect}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_win_1252_bytes_vect(v, siz)

    vv = v;
    vv(v == 129 | v == 141 | v == 143 | v == 144 | v == 157) = 0;
    vv(vv >= 128) = 32;
    ret = is_ascii_bytes_vect(vv, siz);

endfunction

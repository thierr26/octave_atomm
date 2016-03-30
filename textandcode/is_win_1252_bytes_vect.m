## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_win_1252_bytes_vect (@var{v}, @var{siz})
##
## True for a vector of byte values that look like Windows-1252 characters.
##
## @code{is_win_1252_bytes_vect} is meant to be used as third argument to
## function @code{is_ascii_file}.
##
## @var{v} must be a column vector of values of type uint8 and is supposed to
## contain the values of the bytes of a file.  @var{v} does not need to contain
## all the byte values of the file and may only contain the first ones.
## @var{siz} is supposed to be the actual byte size of the file.
##
## @code{is_win_1252_bytes_vect} returns true if the following conditions are
## fulfilled:
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
## @seealso{is_ascii_bytes_vect, is_ascii_file, is_iso_8859_bytes_vect,
## is_utf8_bytes_vect}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_win_1252_bytes_vect(v, siz)

    vv = v;
    vv(v == 129 | v == 141 | v == 143 | v == 144 | v == 157) = 0;
    vv(vv >= 128) = 32;
    ret = is_ascii_bytes_vect(vv, siz);

endfunction

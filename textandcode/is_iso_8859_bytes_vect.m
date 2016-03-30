## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_iso_8859_bytes_vect (@var{v}, @var{siz})
##
## True for a vector of byte values that look like ISO 8859 characters.
##
## @code{is_iso_8859_bytes_vect} is meant to be used as third argument to
## function @code{is_ascii_file}.
##
## @var{v} must be a column vector of values of type uint8 and is supposed to
## contain the values of the bytes of a file.  @var{v} does not need to contain
## all the byte values of the file and may only contain the first ones.
## @var{siz} is supposed to be the actual byte size of the file.
##
## @code{is_iso_8859_bytes_vect} returns true if the following conditions are
## fulfilled:
##
## @itemize @bullet
## @item
## The bytes all have value 9 (tabulation), 10 (line feed) or 13 (carriage
## return), or a value in one of the [32, 126] and [160, 255] ranges.
##
## @item
## Value 13, if present, always precedes value 10.
## @end itemize
##
## @seealso{is_ascii_bytes_vect, is_ascii_file, is_utf8_bytes_vect,
## is_win_1252_bytes_vect}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_iso_8859_bytes_vect(v, siz)

    vv = v;
    vv(v >= 160) = 32;
    ret = is_ascii_bytes_vect(vv, siz);

endfunction

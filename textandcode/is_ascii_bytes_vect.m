## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_ascii_bytes_vect (@var{v}, @var{siz})
##
## True for a vector of byte values that look like ASCII characters.
##
## @code{is_ascii_bytes_vect} is meant to be used as third argument to function
## @code{is_ascii_file}.
##
## @var{v} must be a column vector of values of type uint8 and is supposed to
## contain the values of the bytes of a file.  @var{v} does not need to contain
## all the byte values of the file and may only contain the first ones.
## @var{siz} is supposed to be the actual byte size of the file.
##
## @code{is_ascii_bytes_vect} returns true if the following conditions are
## fulfilled:
##
## @itemize @bullet
## @item
## The bytes all have value 9 (tabulation), 10 (line feed) or 13 (carriage
## return), or a value in the [32, 126] range (ASCII printable characters).
##
## @item
## Value 13, if present, always precedes value 10.
## @end itemize
##
## @seealso{is_ascii_file, is_iso_8859_bytes, is_utf8_bytes_vect,
## is_win_1252_bytes_vect}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_ascii_bytes_vect(v, siz)

    validated_mandatory_args(...
        {@is_uint8_col, @is_natural_integer_scalar}, v, siz);

    ret = all((v == 9 | v == 10 | v == 13 | v > 31) & v < 127);
    if ret
        cRPos = find(v == 13);
        if ~isempty(cRPos) && cRPos(end) == numel(v)
            if numel(v) == siz
                ret = false;
            else
                cRPos = cRPos(1 : end - 1);
            endif
        endif
        if ret
            ret = isempty(cRPos) || all(v(cRPos + 1) == 10);
        endif
    endif

endfunction

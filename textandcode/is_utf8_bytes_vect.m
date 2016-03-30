## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_utf8_bytes_vect (@var{v}, @var{siz})
##
## True for a vector of byte values that look like UTF-8 characters (simplified
## algorithm, may not be accurate).
##
## @code{is_utf8_bytes_vect} is meant to be used as third argument to
## function @code{is_ascii_file}.
##
## @var{v} must be a column vector of values of type uint8 and is supposed to
## contain the values of the bytes of a file.  @var{v} does not need to contain
## all the byte values of the file and may only contain the first ones.
## @var{siz} is supposed to be the actual byte size of the file.
##
## @seealso{is_ascii_bytes_vect, is_ascii_file, is_iso_8859_bytes_vect,
## is_win_1252_bytes_vect}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_utf8_bytes_vect(v, siz)

    vv = v;
    vLen = numel(v);
    ret = true;
    mSBSetIdx = find(v >= 128);
    mSBSepCount = numel(mSBSetIdx);
    k = 0;
    while ret && k < mSBSepCount
        idxCodeStart = mSBSetIdx(k + 1);
        [ret, n] = is_valid_first_byte_in_multi_byte_code(v(idxCodeStart));
        if ret
            idxCodeEnd = min([idxCodeStart + n - 1, vLen]);
            ret = are_valid_trailing_bytes_in_multi_byte_code(...
                v(idxCodeStart + 1 : idxCodeEnd));
            vv(idxCodeStart : idxCodeEnd) = 32;
            k = k + n;
        endif
    endwhile
    ret = ret && is_ascii_bytes_vect(vv, siz);

endfunction

# -----------------------------------------------------------------------------

    # bin2dec('10000000') = 128
    # bin2dec('11000000') = 192
    # bin2dec('11100000') = 224
    # bin2dec('11110000') = 240
    # bin2dec('01000000') =  64
    # bin2dec('00100000') =  32
    # bin2dec('00010000') =  16
    # bin2dec('00001000') =   8

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Return true in valid for a valid first multi-byte code byte and return the
# code byte length in code_len.

function [valid, code_len] = is_valid_first_byte_in_multi_byte_code(byte_value)

    valid = false;
    code_len = 0;
    if bitand(byte_value, 240) == 240
        valid = bitand(byte_value, 8) == 0;
        code_len = 4;
    elseif bitand(byte_value, 224) == 224
        valid = bitand(byte_value, 16) == 0;
        code_len = 3;
    elseif bitand(byte_value, 192) == 192
        valid = bitand(byte_value, 32) == 0;
        code_len = 2;
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# True for a vector of valid trailing bytes in a multi-byte code.

function ret = are_valid_trailing_bytes_in_multi_byte_code(v)

    ret = all(bitand(v, 128) ~= 0 & bitand(v, 64) == 0);

endfunction

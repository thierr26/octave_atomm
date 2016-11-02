## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_ascii_bytes_vect (@var{@
## v}, @var{siz})
##
## True for a vector of ASCII character byte codes.
##
## @code{is_ascii_bytes_vect} is intended to be used to check whether the byte
## values read from a file are ASCII codes or not.  Example:
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
## @var{isASCIIFile} = is_ascii_bytes_vect (@var{v}, @var{siz});
## @end group
## @end example
##
## Note that function @code{file_byte_size} is available in the "fsys" toolbox
## in the Atomm source tree.
##
## Of course, you might use @code{is_ascii_bytes_vect} on a vector that has not
## been read from a file using a statement like
## @code{is_ascii_bytes_vect (@var{v}, numel(@var{v}))};
##
## In any case, @var{v} must be a column vector of values of type uint8.
##
## @code{is_ascii_bytes_vect (@var{v})} returns true if the following
## conditions are fulfilled:
##
## @itemize @bullet
## @item
## Values in @var{v} are all 9 (tabulation), 10 (line feed) or 13 (carriage
## return), or a value in the [32, 126] range (ASCII printable characters).
##
## @item
## Value 13, if present, always precedes value 10.
## @end itemize
##
## Note that @code{is_ascii_bytes_vect} can be used as second argument to
## function @code{is_ascii_file}.
##
## @seealso{fclose, file_byte_size, fopen, fread, is_ascii_file,
## is_iso_8859_bytes_vect, is_utf8_bytes_vect, is_win_1252_bytes_vect}
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

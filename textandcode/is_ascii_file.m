## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_ascii_file (@var{filename})
## @deftypefnx {Function File} {@var{ret} =} is_ascii_file (@var{@
## filename}, @var{func_handle})
## @deftypefnx {Function File} {@var{ret} =} is_ascii_file (@var{@
## filename}, @var{func_handle}, @var{n})
##
## True for a file that looks like an ASCII text file.
##
## @code{@var{ret} = is_ascii_file (@var{filename})} returns true if
## @var{filename} is an ASCII file.
##
## @code{is_ascii_file (@var{filename})} is equivalent to
## @code{is_ascii_file (@var{filename}, @@is_ascii_bytes_vect)}.  You can use
## a handle to another function to divert @code{is_ascii_file} from its
## original purpose and turn it into a function that checks that a file is
## something else than an ASCII text file.  Examples of such functions are
## @code{is_iso_8859_bytes_vect}, @code{is_utf8_bytes_vect} and
## @code{is_win_1252_bytes_vect}.
##
## If the integer @var{n} (third argument) is provided and is greater than 0,
## then @code{is_ascii_file} does not read the whole file but only the @var{n}
## first bytes.  @var{n} defaults to 100000.
##
## @seealso{is_ascii_bytes_vect, is_iso_8859_bytes_vect, is_utf8_bytes_vect,
## is_win_1252_bytes_vect}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_ascii_file(filename, varargin)

    validated_mandatory_args({@is_non_empty_string}, filename);
    [fu, n] = validated_opt_args(...
        {@(x) isa(x, 'function_handle'), @is_ascii_bytes_vect; ...
        @is_integer_scalar, 100000}, varargin{:});

    siz = file_byte_size(filename);

    f = fopen(filename, 'r');
    if n <= 0
        v = fread(f, '*uint8');
    else
        v = fread(f, n, '*uint8');
    endif
    fclose(f);

    ret = fu(v, siz);

endfunction

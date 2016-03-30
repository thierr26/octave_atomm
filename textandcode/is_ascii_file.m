## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_ascii_file (@var{filename})
## @deftypefnx {Function File} is_ascii_file (@var{filename}, @var{@
## func_handle})
## @deftypefnx {Function File} is_ascii_file (@var{filename}, @var{@
## func_handle}, @var{n})
##
## True if the file @var{filename} looks like an ASCII text file.
##
## If the function handle @var{func_handle} (second argument) is provided, then
## the function pointed to by the handle is used to analyse the values of the
## bytes in the file and determine whether it looks like an ASCII text file or
## not.  The function pointed to by the function handle must take a column
## vector of values of type uint8 and the byte size of the file as arguments
## and return a logical scalar.  The vector does not need to have as many bytes
## as the file.
##
## Of course, the function handle argument is an opportunity of diverting
## @code{is_ascii_file} from its original purpose and turn it into a function
## that checks that a file is something else than an ASCII text file.
##
## Examples of such functions are @code{is_iso_8859_bytes_vect},
## @code{is_utf8_bytes_vect} and @code{is_win_1252_bytes_vect}.
##
## If the function handle argument is not provided, then
## @code{is_ascii_bytes_vect} is used.
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

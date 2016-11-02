## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{c} =} text_file_lines (@var{filename})
##
## Lines of a text file.
##
## @code{@var{c} = text_file_lines} returns a cell array of strings in @var{c}.
## Every cell contains a line of the text file @var{filename}.  There is no
## sorting of any kind.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function c = text_file_lines(filename)

    validated_mandatory_args({@is_non_empty_string}, filename);

    # Open the file.
    f = fopen(filename, 'r');

    # Move to the end of the file.
    fseek(f, 0, 'eof');

    if ftell(f) == 0
        # The file has zero bytes.

        c = {};
    else
        # The file has at least one byte.

        # Come back to the beginning of the file.
        fseek(f, 0, 'bof');

        # Read the lines of the file.
        c = textscan(f, '%s', 'Delimiter', '\n', 'whitespace', '');
        c = c{1};
    endif

    # Close the file.
    fclose(f);

endfunction

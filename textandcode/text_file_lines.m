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

    # Get the byte size of the file.
    siz = ftell(f);

    if siz == 0
        # The file has zero bytes.

        c = {};

        # Close the file.
        fclose(f);
    else
        # The file has at least one byte.

        # Come back to the beginning of the file.
        fseek(f, 0, 'bof');

        # Read the lines of the file.
        c = textscan(f, '%s', 'Delimiter', '\n', 'Whitespace', '');
        c = c{1};

        # Close the file.
        fclose(f);

        if is_octave
            # Block added to fix issue #5 ("Function text_file_lines does not
            # "see" empty lines (with Octave, not with Matlab)").

            maxNumberOfEmptyLines = siz - cell_cum_numel(c) - numel(c);
            c = [cell(maxNumberOfEmptyLines, 1); c];
            c(1 : maxNumberOfEmptyLines) = {''};

            f = fopen(filename, 'r');
            n = 0;
            k = maxNumberOfEmptyLines;
            while ~feof(f)
                line = fgetl(f);
                n = n + 1;
                if ~isempty(line)
                    k = k + 1;
                    c{n} = c{k};
                    if n ~= k
                        c{k} = '';
                    endif
                endif
            end;
            fclose(f);

            c = c(1 : n);

        endif
    endif

endfunction

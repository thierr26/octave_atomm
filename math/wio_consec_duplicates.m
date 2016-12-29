## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} {@var{ret} =} wio_consec_duplicates (@var{x})
##
## @code{@var{ret} = wio_consec_duplicates (@var{x})} returns numeric or
## logical row vector @var{x} in @var{ret} with consecutive duplicates removed.
##
##
## Examples:
##
## @example
## @group
## wio_consec_duplicates ([1, 2, 3, 2])
##    @result{} [1, 2, 3, 2]
## @end group
## @end example
##
## @example
## @group
## wio_consec_duplicates ([1, 2, 2, 3, 2])
##    @result{} [1, 2, 3, 2]
## @end group
## @end example
##
## @example
## @group
## wio_consec_duplicates ([true, false, false, true])
##    @result{} [true, false, true]
## @end group
## @end example
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = wio_consec_duplicates(x)

    validated_mandatory_args(...
        {@(x) (isnumeric(x) || islogical(x)) && (isrow(x) || isempty(x))}, x);

    if numel(x) > 1
        ret = x([true diff(x) ~= 0]);
    else
        ret = x;
    endif

endfunction

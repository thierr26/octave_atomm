## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {@
## Function File} wio_consec_duplicates (@var{x})
##
## Return @var{x} (numeric or logical row vector) with consecutive duplicates
## removed.
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

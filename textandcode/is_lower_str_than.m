## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} is_lower_str_than (@var{@
## str1}, @var{str2})
##
## True if sorting places first string argument strictly before the second one.
##
## @code{@var{ret} = is_lower_str_than (@var{str1}, @var{str2})} returns true
## if the strings @var{str1} and @var{str2} are different and @var{str1} comes
## before @var{str2} if both strings are sorted in ascendant order (using
## @code{sort(@{@var{str1}, @var{str2}@})}).
##
## @seealso{sort}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_lower_str_than (str1, str2)

    validated_mandatory_args({@is_string, @is_string}, str1, str2);

    ret = ~strcmp(str1, str2);
    if ret
        [~, idx] = sort({str1, str2});
        ret = all(idx == [1 2]);
    endif

endfunction

## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} is_scalar_num_or_log_literal (@var{str})
##
## True for scalar numerical literals and logical literals.
##
## @code{is_scalar_num_or_log_literal} returns true if the @var{str} is a
## string like:
##
## @itemize @bullet
## @item
## "12"
##
## @item
## "+12"
##
## @item
## "-12"
##
## @item
## "-12.34"
##
## @item
## "-12."
##
## @item
## "-.34"
##
## @item
## ".34"
##
## @item
## "1.234e4"
##
## @item
## "1.234e-4"
##
## @item
## "1.e-4"
##
## @item
## "-1.234e-4"
##
## @item
## "1.234E-4"
##
## @item
## "1.234E+4"
##
## @item
## "1234E+4"
##
## @item
## "true"
##
## @item
## "false"
## @end itemize
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = is_scalar_num_or_log_literal(str)

    validated_mandatory_args({@is_string}, str);

    ret = false;
    if strcmp(str, 'true') || strcmp(str, 'false')
        ret = true;
    else

        # Split by "e" or "E".
        eSplit = regexpi(str, 'e', 'split');

        if any(numel(eSplit) == 1 : 2) && ~isempty(eSplit{1})
            # There is 0 or 1 "e" or "E" and something before "e" or "E".

            # Remove the sign (if any) of the pre-e part.
            eSplit{1} = strip_sign(eSplit{1});

            # Split the pre-e part by ".".
            dSplit = regexp(eSplit{1}, '\.', 'split');

            if any(numel(dSplit) == 1 : 2) && ~all(cellfun(@isempty, dSplit))
                # There is 0 or 1 "." and something before or after ".".

                if is_made_of_digit(dSplit{1})
                    # There is nothing else than digits before ".".

                    if numel(dSplit) == 1 || is_made_of_digit(dSplit{2})
                        # There is nothing else than digits after ".".

                        if numel(eSplit) == 1
                            # There is no "e" or "E".

                            ret = true;
                        elseif ~isempty(eSplit{2})

                            # Remove the sign (if any) of the post-e part.
                            eSplit{2} = strip_sign(eSplit{2});

                            if is_made_of_digit(eSplit{2})
                                # There is nothing else than digits after "e"
                                # or "E".

                                ret = true;
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif

endfunction

# -----------------------------------------------------------------------------

# Remove the sign ("+" or "-") (if any) at first position of a string.

function ss = strip_sign(s)

    if s(1) == '-' || s(1) == '+'
        ss = s(2 : end);
    else
        ss = s;
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# True for empty strings and strings made of digits ("0" to "9").

function ret = is_made_of_digit(s)

    ret = isempty(s) || all(s >= '0' & s <= '9');

endfunction

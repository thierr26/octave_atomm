## Copyright (C) 2017 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} test_physunits ()
##
## Run test case for toolbox "physunits", return results as a structure.
##
## @code{@var{s} = test_physunits ()} actually runs a
## @code{@var{s} = run_test_case (@var{test_case_name}, @var{test_routine})}
## statement.  Please run @code{help run_test_case} for more information about
## function @code{run_test_case} and its output structure.
##
## @table @asis
## @item @var{test_case_name}
## "test_physunits" (function name, given by function @code{mfilename}).
##
## @item @var{test_routine}
## Cell array of handles to local functions (test routines) written
## specifically to test the toolbox "physunits".
## @end table
##
## @seealso{mfilename, run_test_case}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function s = test_physunits

    # Declare the test routines.
    testRoutine = {...
        @is_valid_phys_unit_prefix_list_empty, ...
        @is_valid_phys_unit_prefix_list_true_1, ...
        @is_valid_phys_unit_prefix_list_true_2, ...
        @is_valid_phys_unit_prefix_list_false_1, ...
        @is_valid_phys_unit_prefix_list_false_2, ...
        @is_valid_phys_unit_prefix_list_false_3, ...
        @is_valid_phys_unit_prefix_list_false_4, ...
        @is_valid_phys_unit_prefix_list_false_5, ...
        @is_valid_phys_unit_prefix_list_false_6, ...
        @phys_unit_prefixes_list_no_arg, ...
        @phys_unit_prefixes_list_fail_wrong_list_1, ...
        @phys_unit_prefixes_list_fail_wrong_list_2, ...
        @phys_unit_prefixes_list_fail_wrong_prefix_type_1, ...
        @phys_unit_prefixes_list_fail_wrong_prefix_type_2, ...
        @phys_unit_prefixes_list_fail_wrong_prefix_1, ...
        @phys_unit_prefixes_list_fail_wrong_prefix_2, ...
        @phys_unit_prefixes_list_default_list_1, ...
        @phys_unit_prefixes_list_default_list_2, ...
        @phys_unit_prefixes_list_custom_list, ...
        @phys_unit_prefixes_list_custom_list_empty, ...
        @phys_unit_prefixes_list_custom_list_micro_mc, ...
        @phys_unit_prefixes_list_custom_list_micro_u, ...
        @phys_unit_prefixes_list_custom_list_micro_181, ...
        @phys_unit_prefixes_list_custom_list_micro_u03bc, ...
        @phys_units_system_no_arg, ...
        @phys_units_system_base, ...
        @phys_units_system_base_col, ...
        @phys_units_system_pref, ...
        @phys_units_system_base_pref, ...
        @phys_units_system_pref_base, ...
        @phys_units_system_fail_wrong_base, ...
        @phys_units_system_fail_wrong_pref, ...
        @phys_units_system_fail_double_base, ...
        @phys_units_system_fail_double_pref, ...
        @phys_units_system_fail_dup_in_base, ...
        @phys_units_system_fail_dup_in_pref, ...
        @is_known_phys_unit_true, ...
        @is_known_phys_unit_false, ...
        @is_known_phys_unit_true_default_stru, ...
        @is_known_phys_unit_false_default_stru, ...
        @is_valid_phys_unit_symbol_fail_wrong_type, ...
        @is_valid_phys_unit_symbol_empty, ...
        @is_valid_phys_unit_symbol_true, ...
        @is_valid_phys_unit_symbol_false_1, ...
        @is_valid_phys_unit_symbol_false_2, ...
        @is_valid_phys_unit_symbol_false_3, ...
        @is_valid_phys_unit_symbol_false_4, ...
        @is_valid_phys_unit_symbol_false_5, ...
        @register_phys_unit_fail_wrong_stru, ...
        @register_phys_unit_fail_invalid_symbol, ...
        @register_phys_unit_fail_invalid_dim_length, ...
        @register_phys_unit_fail_non_integer_dim, ...
        @register_phys_unit_fail_wrong_factor_type, ...
        @register_phys_unit_fail_wrong_offset_type, ...
        @register_phys_unit_fail_duplicate, ...
        @register_phys_unit_ok, ...
        @register_phys_unit_ok_factor, ...
        @register_phys_unit_ok_offset, ...
        @register_si_derived_units_no_error, ...
        @common_phys_units_system_no_error, ...
        @common_phys_units_system_prefix_no_error, ...
        @phys_unit_dim_factor_offset_fail_single_dot, ...
        @phys_unit_dim_factor_offset_fail_single_slash, ...
        @phys_unit_dim_factor_offset_fail_double_slash, ...
        @phys_unit_dim_factor_offset_fail_start_with_dot, ...
        @phys_unit_dim_factor_offset_fail_start_with_slash, ...
        @phys_unit_dim_factor_offset_fail_end_with_dot, ...
        @phys_unit_dim_factor_offset_fail_end_with_slash, ...
        @phys_unit_dim_factor_offset_empty_unit_symbol, ...
        @phys_unit_dim_factor_offset_blank_unit_symbol, ...
        @phys_unit_dim_factor_offset_base_unit_m, ...
        @phys_unit_dim_factor_offset_base_unit_kg, ...
        @phys_unit_dim_factor_offset_base_unit_cd, ...
        @phys_unit_dim_factor_offset_base_unit_m_pref_n, ...
        @phys_unit_dim_factor_offset_base_unit_kg_pref_n, ...
        @phys_unit_dim_factor_offset_base_unit_cd_pref_n, ...
        @phys_unit_dim_factor_offset_base_unit_kg_no_pref, ...
        @phys_unit_dim_factor_offset_degc, ...
        @phys_unit_dim_factor_offset_degf, ...
        @phys_unit_dim_factor_offset_mps, ...
        @phys_unit_dim_factor_offset_mps_space, ...
        @phys_unit_dim_factor_offset_kmps, ...
        @phys_unit_dim_factor_offset_kmpms, ...
        @phys_unit_dim_factor_offset_hz, ...
        @phys_unit_dim_factor_offset_khz, ...
        @phys_unit_dim_factor_offset_rad, ...
        @phys_unit_dim_factor_offset_mrad, ...
        @phys_unit_dim_factor_offset_n, ...
        @phys_unit_dim_factor_offset_dan, ...
        @phys_unit_dim_factor_offset_nm, ...
        @phys_unit_dim_factor_offset_nm_no_dot, ...
        @phys_unit_dim_factor_offset_nm_space, ...
        @phys_unit_dim_factor_offset_mkg, ...
        @phys_unit_dim_factor_offset_mkg_no_dot, ...
        @phys_unit_dim_factor_offset_kgm, ...
        @phys_unit_dim_factor_offset_kgm_no_dot, ...
        @phys_unit_dim_factor_offset_mdan, ...
        @phys_unit_dim_factor_offset_mdan_no_dot, ...
        @phys_unit_dim_factor_offset_danm, ...
        @phys_unit_dim_factor_offset_danm_no_dot, ...
        @phys_unit_dim_factor_offset_kwh, ...
        @phys_unit_dim_factor_offset_kwh_no_dot, ...
        @phys_unit_dim_factor_offset_nmps, ...
        @phys_unit_dim_factor_offset_nmps_no_dot, ...
        @phys_unit_dim_factor_offset_sm1, ...
        @phys_unit_dim_factor_offset_hm1, ...
        @phys_unit_dim_factor_offset_msm1, ...
        @phys_unit_dim_factor_offset_kmph, ...
        @phys_unit_dim_factor_offset_kmhm1, ...
        @phys_unit_dim_factor_offset_msm2, ...
        @phys_unit_dim_factor_offset_mps2, ...
        @phys_unit_dim_factor_offset_mpsps, ...
        @phys_unit_dim_factor_offset_kmhm2, ...
        @phys_unit_dim_factor_offset_kmph2, ...
        @phys_unit_dim_factor_offset_kmphph, ...
        @phys_unit_dim_factor_offset_mm, ...
        @phys_unit_dim_factor_offset_km2, ...
        @phys_units_conv_fail_unknown_1, ...
        @phys_units_conv_fail_unknown_2, ...
        @phys_units_conv_fail_incompatible, ...
        @phys_units_conv_poly_degf_degc, ...
        @phys_units_conv_poly_degc_k, ...
        @phys_units_conv_degc_degf, ...
        @phys_units_conv_kmph_mps, ...
        @phys_units_conv_kmph_mps_space, ...
        @phys_units_conv_poly_degcph_kph, ...
        @phys_units_conv_default_stru_pol, ...
        @phys_units_conv_default_stru_val};

    # Run the test case.
    s = run_test_case(mfilename, testRoutine);

endfunction

# -----------------------------------------------------------------------------

function ret = is_valid_phys_unit_prefix_list_empty

    ret = is_valid_phys_unit_prefix_list({});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_prefix_list_true_1

    ret = is_valid_phys_unit_prefix_list({'k', 1e3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_prefix_list_true_2

    ret = is_valid_phys_unit_prefix_list({'k', 1e3; 'm', 1e-3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_prefix_list_false_1

    ret = ~is_valid_phys_unit_prefix_list({'k', 1e3; ' ', 1e-3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_prefix_list_false_2

    ret = ~is_valid_phys_unit_prefix_list({'k', 1e3; '', 1e-3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_prefix_list_false_3

    ret = ~is_valid_phys_unit_prefix_list({'k', 1e3; 'm', -1e-3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_prefix_list_false_4

    ret = ~is_valid_phys_unit_prefix_list({'k', 1e3; 'k', 1e3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_prefix_list_false_5

    ret = ~is_valid_phys_unit_prefix_list({'k', 1e3; true, 1e-3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_prefix_list_false_6

    ret = ~is_valid_phys_unit_prefix_list({'k', 1e3; 'm', true});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_prefixes_list_no_arg

    ret = is_valid_phys_unit_prefix_list(phys_unit_prefixes);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_prefixes_list_fail_wrong_list_1

    phys_unit_prefixes({'k', 1e3; '', 1e-3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_prefixes_list_fail_wrong_list_2

    phys_unit_prefixes({'k', 1e3; '', 1e-3}, 'k');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_prefixes_list_fail_wrong_prefix_type_1

    phys_unit_prefixes(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_prefixes_list_fail_wrong_prefix_type_2

    phys_unit_prefixes({'k', 1e3; 'm', 1e-3}, true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_prefixes_list_fail_wrong_prefix_1

    phys_unit_prefixes('x');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_prefixes_list_fail_wrong_prefix_2

    phys_unit_prefixes({'k', 1e3; 'm', 1e-3}, 'x');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_prefixes_list_default_list_1

    ret = phys_unit_prefixes('da') == 10;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_prefixes_list_default_list_2

    ret = phys_unit_prefixes('m') == 0.001;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_prefixes_list_custom_list

    ret = phys_unit_prefixes (phys_unit_prefix_list_micro_mc, 'da') == 10;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_prefixes_list_custom_list_empty

    phys_unit_prefixes ({}, 'da');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_prefixes_list_custom_list_micro_mc

    ret = phys_unit_prefixes (phys_unit_prefix_list_micro_mc, 'mc') == 1e-6;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_prefixes_list_custom_list_micro_u

    ret = phys_unit_prefixes (phys_unit_prefix_list_micro_u, 'u') == 1e-6;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_prefixes_list_custom_list_micro_181

    ret = phys_unit_prefixes (...
        phys_unit_prefix_list_micro_extended_ascii_181, char(181)) == 1e-6;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_prefixes_list_custom_list_micro_u03bc

    ret = phys_unit_prefixes (...
        phys_unit_prefix_list_micro_u03bc, char([206 188])) == 1e-6;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_system_no_arg

    ret = isequal(phys_units_system, ...
        struct(...
            'base_units', {base_phys_units}, ...
            'prefix_list', {phys_unit_prefixes}, ...
            'other_units', {cell(0, 4)}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_system_base

    b = {'imaginary_unit_one', 'imaginary_unit_two'};
    ret = isequal(phys_units_system (b), ...
        struct(...
            'base_units', {b}, ...
            'prefix_list', {phys_unit_prefixes}, ...
            'other_units', {cell(0, 4)}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_system_base_col

    b = {'imaginary_unit_one'; 'imaginary_unit_two'};
    ret = isequal(phys_units_system (b), ...
        struct(...
            'base_units', {b'}, ...
            'prefix_list', {phys_unit_prefixes}, ...
            'other_units', {cell(0, 4)}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_system_pref

    ret = isequal(phys_units_system(phys_unit_prefix_list_micro_u), ...
        struct(...
            'base_units', {base_phys_units}, ...
            'prefix_list', {phys_unit_prefix_list_micro_u}, ...
            'other_units', {cell(0, 4)}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_system_base_pref

    b = {'imaginary_unit_one', 'imaginary_unit_two'};
    ret = isequal(phys_units_system(b, phys_unit_prefix_list_micro_u), ...
        struct(...
            'base_units', {b}, ...
            'prefix_list', {phys_unit_prefix_list_micro_u}, ...
            'other_units', {cell(0, 4)}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_system_pref_base

    b = {'imaginary_unit_one', 'imaginary_unit_two'};
    ret = isequal(phys_units_system(phys_unit_prefix_list_micro_u, b), ...
        struct(...
            'base_units', {b}, ...
            'prefix_list', {phys_unit_prefix_list_micro_u}, ...
            'other_units', {cell(0, 4)}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_units_system_fail_wrong_base

    b = {'imaginary_unit_one', ' '};
    phys_units_system(phys_unit_prefix_list_micro_u, b);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_units_system_fail_wrong_pref

    b = {'imaginary_unit_one', 'imaginary_unit_two'};
    phys_units_system({'k', 1e3; '', 1e-3}, b);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_units_system_fail_double_base

    phys_units_system(base_phys_units, phys_unit_prefixes, base_phys_units);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_units_system_fail_double_pref

    phys_units_system(phys_unit_prefixes, base_phys_units, phys_unit_prefixes);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_units_system_fail_dup_in_base

    phys_units_system({'a', 'b', 'a'});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_units_system_fail_dup_in_pref

    phys_units_system({'a', 1e3; 'b', 1e6; 'a', 1e-3});

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_known_phys_unit_true

    ret = is_known_phys_unit(phys_units_system, 'm');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_known_phys_unit_false

    ret = ~is_known_phys_unit(phys_units_system, 'x');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_known_phys_unit_true_default_stru

    ret = is_known_phys_unit('m');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_known_phys_unit_false_default_stru

    ret = ~is_known_phys_unit('x');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_valid_phys_unit_symbol_fail_wrong_type

    is_valid_phys_unit_symbol(true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_symbol_empty

    ret = ~is_valid_phys_unit_symbol('');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_symbol_true

    ret = is_valid_phys_unit_symbol('Hz');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_symbol_false_1

    ret = ~is_valid_phys_unit_symbol('m2');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_symbol_false_2

    ret = ~is_valid_phys_unit_symbol('deg C');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_symbol_false_3

    ret = ~is_valid_phys_unit_symbol('deg-C');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_symbol_false_4

    ret = ~is_valid_phys_unit_symbol('m/s');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = is_valid_phys_unit_symbol_false_5

    ret = ~is_valid_phys_unit_symbol('N.m');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function register_phys_unit_fail_wrong_stru

    register_phys_unit(true, 'h', [0 0 1 0 0 0 0]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function register_phys_unit_fail_invalid_symbol

    register_phys_unit(phys_units_system, 'h2', [0 0 1 0 0 0 0]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function register_phys_unit_fail_invalid_dim_length

    register_phys_unit(phys_units_system, 'h', [0 0 1 0 0 0]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function register_phys_unit_fail_non_integer_dim

    register_phys_unit(phys_units_system, 'h', [0 0 0.5 0 0 0 0]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function register_phys_unit_fail_wrong_factor_type

    register_phys_unit(phys_units_system, 'h', [0 0 1 0 0 0 0], true);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function register_phys_unit_fail_wrong_offset_type

    register_phys_unit(phys_units_system, 'h', [0 0 1 0 0 0 0], 3600, false);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function register_phys_unit_fail_duplicate

    s = register_phys_unit(phys_units_system, 'Hz', [0 0 -1 0 0 0 0]);
    register_phys_unit(s, 'Hz', [0 0 -1 0 0 0 0]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = register_phys_unit_ok

    c = {'Hz', [0 0 -1 0 0 0 0]};
    s = register_phys_unit(phys_units_system, c{:});
    ret = isequal(s.other_units(end, :), [c {1, 0}]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = register_phys_unit_ok_factor

    c = {'h', [0 0 1 0 0 0 0], 3600};
    s = register_phys_unit(phys_units_system, c{:});
    ret = isequal(s.other_units(end, :), [c {0}]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = register_phys_unit_ok_offset

    c = {'degC', [0 0 0 0 1 0 0], 1, -273.15};
    s = register_phys_unit(phys_units_system, c{:});
    ret = isequal(s.other_units(end, :), c);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = register_si_derived_units_no_error

    register_si_derived_units(phys_units_system);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = common_phys_units_system_no_error

    common_phys_units_system;
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = common_phys_units_system_prefix_no_error

    common_phys_units_system(phys_unit_prefix_list_micro_mc);
    ret = true;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_dim_factor_offset_fail_single_dot

    phys_unit_dim_factor_offset(common_phys_units_system, '.');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_dim_factor_offset_fail_single_slash

    phys_unit_dim_factor_offset(common_phys_units_system, '/');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_dim_factor_offset_fail_double_slash

    phys_unit_dim_factor_offset(common_phys_units_system, '//');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_dim_factor_offset_fail_start_with_dot

    phys_unit_dim_factor_offset(common_phys_units_system, '.s');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_dim_factor_offset_fail_start_with_slash

    phys_unit_dim_factor_offset(common_phys_units_system, '/s');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_dim_factor_offset_fail_end_with_dot

    phys_unit_dim_factor_offset(common_phys_units_system, 's.');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_unit_dim_factor_offset_fail_end_with_slash

    phys_unit_dim_factor_offset(common_phys_units_system, 's/');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_empty_unit_symbol

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, '');
    ret = isequal(dim, zeros(1, 7)) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_blank_unit_symbol

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, '  ');
    ret = isequal(dim, zeros(1, 7)) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_base_unit_m

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'm');
    ret = isequal(dim, [1 zeros(1, 6)]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_base_unit_kg

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'kg');
    ret = isequal(dim, [0 1 zeros(1, 5)]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_base_unit_cd

    [dim, f, o] = phys_unit_dim_factor_offset (common_phys_units_system, 'cd');
    ret = isequal(dim, [zeros(1, 6) 1]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_base_unit_m_pref_n

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'nm');
    ret = isequal(dim, [1 zeros(1, 6)]) ...
        && isequal(f, 1e-9) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_base_unit_kg_pref_n

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'ng');
    ret = isequal(dim, [0 1 zeros(1, 5)]) ...
        && isequal(f, 1e-12) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_base_unit_cd_pref_n

    [dim, f, o] ...
        = phys_unit_dim_factor_offset(common_phys_units_system, 'ncd');
    ret = isequal(dim, [zeros(1, 6) 1]) ...
        && isequal(f, 1e-9) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_base_unit_kg_no_pref

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'g');
    ret = isequal(dim, [0 1 zeros(1, 5)]) ...
        && isequal(f, 1e-3) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_degc

    s = common_phys_units_system;
    s = register_phys_unit(s, 'degC', [0 0 0 0 1 0 0], 1, -273.15);
    s = register_phys_unit(s, 'degF', [0 0 0 0 1 0 0], 5 / 9, -459.67);
    [dim, f, o] = phys_unit_dim_factor_offset(s, 'degC');
    ret = isequal(dim, [zeros(1, 4) 1 zeros(1, 2)]) ...
        && isequal(f, 1) ...
        && isequal(o, -273.15);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_degf

    s = common_phys_units_system;
    s = register_phys_unit(s, 'degC', [0 0 0 0 1 0 0], 1, -273.15);
    s = register_phys_unit(s, 'degF', [0 0 0 0 1 0 0], 5 / 9, -459.67);
    [dim, f, o] = phys_unit_dim_factor_offset(s, 'degF');
    ret = isequal(dim, [zeros(1, 4) 1 zeros(1, 2)]) ...
        && isequal(f, 5 / 9) ...
        && isequal(o, -459.67);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mps

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'm/s');
    ret = isequal(dim, [1 0 -1 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mps_space

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'm / s');
    ret = isequal(dim, [1 0 -1 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kmps

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'km/s');
    ret = isequal(dim, [1 0 -1 0 0 0 0]) ...
        && isequal(f, 1e3) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kmpms

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'km/ms');
    ret = isequal(dim, [1 0 -1 0 0 0 0]) ...
        && isequal(f, 1e6) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_hz

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'Hz');
    ret = isequal(dim, [0 0 -1 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_khz

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'kHz');
    ret = isequal(dim, [0 0 -1 0 0 0 0]) ...
        && isequal(f, 1e3) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_rad

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'rad');
    ret = isequal(dim, [0 0 0 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mrad

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'mrad');
    ret = isequal(dim, [0 0 0 0 0 0 0]) ...
        && isequal(f, 1e-3) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_n

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'N');
    ret = isequal(dim, [1 1 -2 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_dan

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'daN');
    ret = isequal(dim, [1 1 -2 0 0 0 0]) ...
        && isequal(f, 10) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_nm

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'N.m');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_nm_no_dot

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'Nm');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_nm_space

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'N m');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mkg

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'm.kg');
    ret = isequal(dim, [1 1 0 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mkg_no_dot

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'mkg');
    ret = isequal(dim, [1 1 0 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kgm

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'kg.m');
    ret = isequal(dim, [1 1 0 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kgm_no_dot

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'kgm');
    ret = isequal(dim, [1 1 0 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mdan

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'm.daN');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 10) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mdan_no_dot

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'mdaN');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 10) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_danm

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'daN.m');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 10) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_danm_no_dot

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'daNm');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 10) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kwh

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'kW.h');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 3.6e6) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kwh_no_dot

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'kWh');
    ret = isequal(dim, [2 1 -2 0 0 0 0]) ...
        && isequal(f, 3.6e6) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_nmps

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'N.m/s');
    ret = isequal(dim, [2 1 -3 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_nmps_no_dot

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'Nm/s');
    ret = isequal(dim, [2 1 -3 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_sm1

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 's-1');
    ret = isequal(dim, [0 0 -1 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_hm1

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'h-1');
    ret = isequal(dim, [0 0 -1 0 0 0 0]) ...
        && isequal(f, 1 / 3600) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_msm1

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'm.s-1');
    ret = isequal(dim, [1 0 -1 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kmph

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'km/h');
    ret = isequal(dim, [1 0 -1 0 0 0 0]) ...
        && isequal(f, 1 / 3.6) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kmhm1

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'km.h-1');
    ret = isequal(dim, [1 0 -1 0 0 0 0]) ...
        && isequal(f, 1 / 3.6) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_msm2

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'm.s-2');
    ret = isequal(dim, [1 0 -2 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mps2

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'm/s2');
    ret = isequal(dim, [1 0 -2 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mpsps

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'm/s/s');
    ret = isequal(dim, [1 0 -2 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kmhm2

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'km.h-2');
    ret = isequal(dim, [1 0 -2 0 0 0 0]) ...
        && isequal(f, 1e3 / 3600 / 3600) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kmph2

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'km/h2');
    ret = isequal(dim, [1 0 -2 0 0 0 0]) ...
        && isequal(f, 1e3 / 3600 / 3600) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_kmphph

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, ...
        'km/h/h');
    ret = isequal(dim, [1 0 -2 0 0 0 0]) ...
        && isequal(f, 1e3 / 3600 / 3600) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_mm

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'm.m');
    ret = isequal(dim, [2 0 0 0 0 0 0]) ...
        && isequal(f, 1) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_unit_dim_factor_offset_km2

    [dim, f, o] = phys_unit_dim_factor_offset(common_phys_units_system, 'km2');
    ret = isequal(dim, [2 0 0 0 0 0 0]) ...
        && isequal(f, 1e6) ...
        && isequal(o, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_units_conv_fail_unknown_1

    phys_units_conv(common_phys_units_system, 'xm', 'm');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function phys_units_conv_fail_unknown_2

    phys_units_conv(common_phys_units_system, 'm', 'xm');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function phys_units_conv_fail_incompatible

    phys_units_conv(common_phys_units_system, 'J', 'W');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_conv_poly_degf_degc

    s = common_phys_units_system;
    s = register_phys_unit (s, 'degC', [0 0 0 0 1 0 0], 1, -273.15);
    s = register_phys_unit (s, 'degF', [0 0 0 0 1 0 0], 5 / 9, -459.67);
    pol = phys_units_conv(s, 'degF', 'degC');
    ret = isequal(pol, [5 / 9, -(5 / 9 * (-459.67)) - 273.15]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_conv_poly_degc_k

    s = common_phys_units_system;
    s = register_phys_unit (s, 'degC', [0 0 0 0 1 0 0], 1, -273.15);
    s = register_phys_unit (s, 'degF', [0 0 0 0 1 0 0], 5 / 9, -459.67);
    pol = phys_units_conv(s, 'degC', 'K');
    ret = isequal(pol, [1, 273.15]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_conv_degc_degf

    s = common_phys_units_system;
    s = register_phys_unit (s, 'degC', [0 0 0 0 1 0 0], 1, -273.15);
    s = register_phys_unit (s, 'degF', [0 0 0 0 1 0 0], 5 / 9, -459.67);
    inp = [-273.15 0 100]';
    v = phys_units_conv(s, 'degC', 'degF', inp);
    ret = isequal(v, ...
        polyval([1 / (5 / 9), -(1 / (5 / 9) * (-273.15)) - 459.67], inp));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_conv_kmph_mps

    s = common_phys_units_system;
    ret = isequal(phys_units_conv(s, 'km/h', 'm/s', 90), 25);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_conv_kmph_mps_space

    s = common_phys_units_system;
    ret = isequal(phys_units_conv(s, 'km / h', 'm/s', 90), 25);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_conv_poly_degcph_kph

    s = common_phys_units_system;
    s = register_phys_unit (s, 'degC', [0 0 0 0 1 0 0], 1, -273.15);
    s = register_phys_unit (s, 'degF', [0 0 0 0 1 0 0], 5 / 9, -459.67);
    pol = phys_units_conv(s, 'degC/h', 'K/h');
    ret = isequal(pol, [1, 0]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_conv_default_stru_pol

    ret = isequal(phys_units_conv('km/h', 'm/s'), [1 / 3.6, 0]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ret = phys_units_conv_default_stru_val

    ret = isequal(phys_units_conv('km/h', 'm/s', 90), 25);

endfunction

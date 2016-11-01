## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{@
## stripped} =} strip_defaults_from_config_stru (@var{cf}, @var{ori})
##
## Strip "factory defaults" parameters from configuration structure.
##
## @code{strip_defaults_from_config_stru} takes the kind of arguments
## (structures @var{cf} and @var{ori}) that are returned by
## @code{default_config} or @code{apply_config_args} and returns a structure
## identical to @var{cf} except that the fields that are set to "Default" in
## @var{ori} are removed.
##
## The field list of @var{cf} must be identical to or be a subset of the field
## list of @var{ori}.  @var{ori} must be a scalar structure.
##
## @code{strip_defaults_from_config_stru} is not useful in every application.
## The demonstration application Mental Sum@footnote{Mental Sum is a simple
## demonstration application aiming at demonstrating how the applications
## provided in the Atomm source tree (Toolman, Checkmtree and Outman) are
## build.  Please issue a @code{help mentalsum} command for all the details.}
## does not use it but Checkmtree and Toolman use it in their
## @code{run_command} private functions to build the structure argument to
## @code{outman_connect_and_config_if_master} containing only the Outman
## configuration parameters that must not be set to their default values.
##
## @seealso{apply_config_args, default_config, mentalsum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = strip_defaults_from_config_stru(cf, ori)

    validated_mandatory_args({@isstruct, @(x) isstruct(x) && isscalar(x)}, ...
        cf, ori);
    [f, n] = field_names_and_count(cf);
    keep = true(1, n);

    for k = 1 : n
        if ~isfield(ori, f{k})
            error('%s is not a field of the second argument structure', f{k});
        endif
        if ~is_string(ori.(f{k}))
            error(['Field %s of the second argument structure is not a ' ...
                'string'], f{k});
        endif
        if strcmp(ori.(f{k}), 'Default')
            keep(k) = false;
        endif
    endfor
    ret = clean_up_struct(cf, f(keep));

endfunction

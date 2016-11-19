## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} log_dirs_err_if_non_existent (@var{@
## leader_str}, @var{top})
##
## Log a directories list and log error messages for non existent directories.
##
## @code{log_dirs_err_if_non_existent (@var{leader_str}, @var{top})} connects
## to Outman, issues one Outman @qcode{"logf"} command to log string
## @var{leader_str} and then issues one Outman @qcode{"logf"} command for each
## unique string provided in @var{top}.
##
## @var{top} can be a simple non empty string or a cell array of non empty
## strings.  The strings provided in @var{top} are supposed to be absolute or
## relative directory names.  For each directory that is non existent,
## @code{log_dirs_err_if_non_existent} issues an Outman @qcode{"errorf"}
## command to display and log error messages.
##
## Finally, @code{log_dirs_err_if_non_existent} disconnects from Outman.
##
## Note that @code{log_dirs_err_if_non_existent} does not attempt to set the
## log file directory and name.  @code{log_dirs_err_if_non_existent} connects
## to Outman using a @code{outman_connect_and_config_if_master} statement with
## no arguments (and thus no attempt to setup Outman with a non default
## configuration).  If you need Outman configured with non default parameters,
## then you must make sure that a master caller has already started up Outman
## with a configuration that fits your needs.
##
## @seealso{outman, outman_connect_and_config_if_master}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function log_dirs_err_if_non_existent(leader_str, top)

    validated_mandatory_args(...
        {@is_string, @string_or_cellstr_arg_or_none}, leader_str, top);

    oId = outman_connect_and_config_if_master;

    if ischar(top)
        topU = {top};
    else
        topU = unique(top);
    endif

    absPath = topU;
    outman('logf', oId, '\n%s', leader_str);
    for k = 1 : numel(topU)
        absPath{k} = absolute_path(topU{k});
        outman('logf', oId, '%s', absPath{k});
    endfor
    outman('logf', oId, '');

    for k = 1 : numel(absPath)
        if exist(absPath{k}, 'dir') ~= 7
            outman('errorf', oId, 'Directory %s does not exist', absPath{k});
        endif
    endfor

    outman('disconnect', oId);

endfunction

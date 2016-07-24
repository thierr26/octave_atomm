## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} log_dirs_err_if_non_existent (@var{@
## leader_str}, @var{top})
##
## Write a directories list to a log file using Outman "logf" commands, and
## inform about non existent directories using Outman "errorf" commands.
##
## Note that @code{log_dirs_err_if_non_existent} does not attempt to set the
## log file directory and name.  @code{log_dirs_err_if_non_existent} connects
## to Outman using a @code{outman_connect_and_config_if_master} statement with
## no arguments (and thus no attempt to setup Outman with a non default
## configuration).  If you need Outman configured with non default parameters,
## then you must make sure that a master caller has already setup Outman
## according to your needs.
##
## @var{leader_str} is a string that is written just before the directories
## list in the log file.
##
## @var{top} is the directories list.  Actually, it can be a single string or a
## cell array of strings.  The directories can be proovided as relative or
## absolute directory names.
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

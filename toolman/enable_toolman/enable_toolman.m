## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @defmac enable_toolman
##
## Add Toolman's dependencies to the function search path.
##
## @seealso{toolman}
## @end defmac

## Author: Thierry Rascle <thierr26@free.fr>

if exist('atommDir', 'var') == 1
    error(['Variable "atommDir" exists in base workspace. Script "%s" ' ...
        'aborts to avoid overwriting and clearing the variable. Clear ' ...
        'variable "atommDir" from workspace before attempting to run ' ...
        'script "%s" again'], mfilename, mfilename);
else

    atommDir = fileparts(fileparts(fileparts(mfilename('fullpath'))));

    addpath(fullfile(atommDir, 'appmech'));
    addpath(fullfile(atommDir, 'argcheck'));
    addpath(fullfile(fullfile(atommDir, 'checkmtree'), 'lib_checkmtree'));
    addpath(fullfile(atommDir, 'datetime'));
    addpath(fullfile(atommDir, 'env'));
    addpath(fullfile(atommDir, 'fsys'));
    addpath(fullfile(atommDir, 'isthisa'));
    addpath(fullfile(atommDir, 'math'));
    addpath(fullfile(atommDir, 'outman'));
    addpath(fullfile(fullfile(atommDir, 'outman'), 'lib_outman'));
    addpath(fullfile(atommDir, 'structure'));
    addpath(fullfile(atommDir, 'tester'));
    addpath(fullfile(atommDir, 'textandcode'));
    addpath(fullfile(fullfile(atommDir, 'textandcode'), 'mlang'));
    addpath(fullfile(atommDir, 'toolman'));
    addpath(fullfile(fullfile(atommDir, 'toolman'), 'lib_toolman'));

    clear atommDir;

endif

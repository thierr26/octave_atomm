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

addpath(fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))), ...
    'env'));
addpath(fullfile(atomm_root(...
    fileparts(fileparts(fileparts(mfilename('fullpath'))))), 'appmech'));
addpath(fullfile(atomm_root, 'argcheck'));
addpath(fullfile(fullfile(atomm_root, 'checkmtree'), 'lib_checkmtree'));
addpath(fullfile(atomm_root, 'datetime'));
addpath(fullfile(atomm_root, 'fsys'));
addpath(fullfile(atomm_root, 'isthisa'));
addpath(fullfile(atomm_root, 'math'));
addpath(fullfile(atomm_root, 'outman'));
addpath(fullfile(fullfile(atomm_root, 'outman'), 'lib_outman'));
addpath(fullfile(atomm_root, 'structure'));
addpath(fullfile(atomm_root, 'tester'));
addpath(fullfile(atomm_root, 'textandcode'));
addpath(fullfile(fullfile(atomm_root, 'textandcode'), 'mlang'));
addpath(fullfile(atomm_root, 'toolman'));
addpath(fullfile(fullfile(atomm_root, 'toolman'), 'lib_toolman'));

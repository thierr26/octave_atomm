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
addpath(fullfile(atomm_dir(...
    fileparts(fileparts(fileparts(mfilename('fullpath'))))), 'appmech'));
addpath(fullfile(atomm_dir, 'argcheck'));
addpath(fullfile(fullfile(atomm_dir, 'checkmtree'), 'lib_checkmtree'));
addpath(fullfile(atomm_dir, 'datetime'));
addpath(fullfile(atomm_dir, 'fsys'));
addpath(fullfile(atomm_dir, 'isthisa'));
addpath(fullfile(atomm_dir, 'math'));
addpath(fullfile(atomm_dir, 'outman'));
addpath(fullfile(fullfile(atomm_dir, 'outman'), 'lib_outman'));
addpath(fullfile(atomm_dir, 'structure'));
addpath(fullfile(atomm_dir, 'tester'));
addpath(fullfile(atomm_dir, 'textandcode'));
addpath(fullfile(fullfile(atomm_dir, 'textandcode'), 'mlang'));
addpath(fullfile(atomm_dir, 'toolman'));
addpath(fullfile(fullfile(atomm_dir, 'toolman'), 'lib_toolman'));

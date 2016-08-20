## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function s = alias_stru

    s = struct();
    s(1).q = {'quit'};
    s.exit = {'quit'};
    s.bye = {'quit'};
    s.clear = {'quit'};
    s.get_config = {'configure'};

endfunction

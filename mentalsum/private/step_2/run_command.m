function [clear_req, s, varargout] = run_command(c, cargs, cf, o, s1, nout, a)

    clear_req = false;
    s = s1;

    if ~mislocked('mentalsum') % The application is starting up.
        fprintf('Configuration parameters:\n');
        cmp1 = 'Session specific';
        cmp2 = 'Configuration argument';
        for cf_param_name = fieldnames(cf)'
            name = cf_param_name{1};
            if strcmp(o.(name), 'Default')
                origin = 'factory defined default value';
            elseif strncmp(o.(name), cmp1, numel(cmp1))
                origin = ['application data "' a '" for handle 0'];
            elseif strncmp(o.(name), cmp2, numel(cmp2))
                origin = ...
                    'configuration argument on startup statement';
            end
            fprintf('  %14s = %8d (%s)\n', name, cf.(name), origin);
        end
        fprintf('\n');
    end

    switch c

        case 'quit'
            clear_req = true;

        case 'play'
            1; % Do nothing.

    end

end

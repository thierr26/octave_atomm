function [clear_req, s, varargout] = run_command(c, cargs, cf, o, s1, nout, a)

    clear_req = false;
    s = s1;

    switch c

        case 'quit'
            clear_req = true;

        case 'play'
            1; % Do nothing.

    end

end

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
        oD = cf.operand_digits;
        s.deg_1_poly_coefs = [10^oD - 1 - 10^(oD - 1), 10^(oD - 1)];
        s.evaluated = 0;
        s.correct = 0;
        s.cum_duration = 0;
    end

    switch c

        case 'quit'
            clear_req = true;

        case 'play'
            if isempty(cargs)
                n = cf.burst_count;
            else
                n = cargs{1};
            end
            for k = 1 : n
                [correct, duration] = add(...
                    draw_op(s.deg_1_poly_coefs), ...
                    draw_op(s.deg_1_poly_coefs));
                s.evaluated = s.evaluated + 1;
                if correct
                    s.correct = s.correct + 1;
                    s.cum_duration = s.cum_duration + duration;
                end
            end

        case 'result'
            if s.evaluated == 0
                error('Please run the "play" command first');
            end
            varargout = {...
                s.evaluated, ...
                s.correct, ...
                s.cum_duration / s.correct};
            fprintf(...
                '%d Additions evaluated, %d correct answers.\n', ...
                varargout{1}, varargout{2});
            fprintf(...
                '%.2fs to give a right answer (mean time).\n', ...
                varargout{3});

    end

end

# -----------------------------------------------------------------------------

function [correct, duration] = add(operand1, operand2)

    done = false;
    loopCount = 0;
    while ~done
        if loopCount == 0
            tic;
        end
        answer = input(...
            sprintf('%d + %d = ? ', operand1, operand2), 's');
        done = is_matched_by(answer, '^\s*-?[0-9]+\s*$');
        if ~done
            fprintf('Please enter a literal integer.\n');
        else
            duration = toc;
        end
        loopCount = loopCount + 1;
    end
    correct = str2double(answer) == operand1 + operand2;
    if correct
        fprintf('Correct!\n\n');
    else
        fprintf('Wrong!\n\n');
    end

end

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function op = draw_op(deg_1_poly_coefs)

    op = floor(polyval(deg_1_poly_coefs, rand(1)));

end

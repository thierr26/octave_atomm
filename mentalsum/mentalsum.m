## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} mentalsum ('play')
## @deftypefnx {Function File} mentalsum ('play', @var{iter})
## @deftypefnx {Function File} {[@var{right_ans}, @var{@
## mean_delay}] =} mentalsum ('result')
## @deftypefnx {Function File} mentalsum ('quit')
##
## Play a mental sum game (sample use of Atomm's application template).
##
## Mental Sum is a game (admittedly not the funniest game but it is good as an
## example) where the user must give the results for integer additions.  This
## application has actually been written to show how to use the application
## template provided in the Atomm source tree.  This help explains what is the
## application template and how to use it by the example of the Mental Sum
## application.
##
## @strong{Build configurable singleton applications using the template.}
##
## The idea behind the application template is to allow to build easily
## singleton applications endowed with:
##
## @itemize @bullet
## @item Configurability i.e., the ability to be started up with default or
## customized and validated configuration parameters (the application templates
## ensures that the configuration parameters don't change until the application
## is shut down by the user and restarted).
##
## @item Protected internal state i.e., there is no other way than invoking the
## application itself through the defined commands to update the application
## internal state, as the state is stored in an internal persistent variable
## structure.
##
## @item Command arguments checking.
##
## @item Command aliasing.
## @end itemize
##
## @strong{Use the template as the main program for all your applications.}
##
## The main program of Mental Sum (i.e.@ the file mentalsum.m) is actually the
## application template.  All the applications provided in the Atomm source
## tree (Toolman, Checkmtree, Outman and Mental Sum) have identical main
## programs.  Of course, the help section and the function signature differ but
## the bodies of the functions are strictly identical.
##
## In the case of Mental Sum, the function signature is:
##
## @example
## @group
## function varargout = mentalsum(varargin)
## @end group
## @end example
##
## In this signature, only the token @qcode{"mentalsum"} is specific to the
## Mental Sum application.  The rest is common to all applications.
##
## @strong{Define the specifics of your applications in private functions.}
##
## The main program of an application calls private functions that return
## structures or implement functionalities that are specific to your
## applications.
##
## The names of the private functions is hard coded in the main program
## template.  This implies that in most cases you can't put multiple
## applications in the same toolbox (i.e.@ in the same directory).  If you look
## in the Atomm source tree, you see that all the applications (Toolman,
## Checkmtree, Outman and Mental Sum) are in a different directory.  This does
## not mean that their can't be other M-files in the toolbox of an application,
## but the other M-files are not applications based on the application
## template.  As an example, see the outman toolbox in the Atomm source.  In
## this directory there is the file outman.m is which the Outman main program
## based on the application template.  There is also other M-files
## (outman_connect_and_config_if_master.m and outman_kill.m) that are "normal"
## functions.
##
## The list of the private functions that the main program calls is:
##
## @table @asis
## @item @code{app_name}
## Returns the application name.
##
## @item @code{config_stru}
## Returns the configuration structure (i.e.@ the structure providing the names
## of the application configuration parameters, their "factory defined" default
## values and the associated validation functions).
##
## @item @code{command_stru_and_default}
## Returns the command structure (i.e.@ the structure providing the names of
## the application commands and the associated arguments validation functions)
## and the name of the default command.
##
## @item @code{alias_stru}
## Returns the alias structure (i.e.@ the structure that defines command
## aliases).
##
## @item @code{run_command}
## Runs the commands (that's where the application business logic is defined).
## @end table
##
## A step by step description of the writing of the private functions for
## Mental Sum follows.  The files for those private functions are available in
## the subdirectories of the private directory of the mentalsum toolbox.
##
## @strong{Step 1: Start up, shut down.}
##
## Let's write minimal versions of the private functions.  This will lead to an
## application that we can start up and shut down.
##
## The @code{app_name} private function is pretty easy to write.  In the case
## of Mental Sum, its text is:
##
## @example
## @group
## function ret = app_name
##
##     ret = 'mentalsum';
##
## end
## @end group
## @end example
##
## @code{app_name} must return a non empty string.  The recommendation is to
## have it return the name of the application main program.
##
## A minimal @code{config_stru} private function returns a structure without
## any fields.  This means that the application still has no configuration
## parameters.  We will add some later.
##
## @example
## @group
## function stru = config_stru
##
##     stru = struct();
##
## end
## @end group
## @end example
##
## The @code{command_stru_and_default} private function must return a structure
## that defines at least 2 commands: One command that does@dots{} something,
## and one that shuts down the application.  Let's call the former
## @qcode{"play"}.  It will be the command that the user uses to play by
## issuing statements like:
##
## @example
## @group
## mentalsum ('play'); % No command arguments given.
## @end group
## @end example
##
## or
##
## @example
## @group
## mentalsum ('play', 10); % One command arguments given.
## @end group
## @end example
##
## The user will have the choice of providing an argument to specify the number
## of integer additions he wants to evaluate.  If the user does not provide
## this argument, the application will use a default number instead.
##
## The structure returned by @code{command_stru_and_default} must provide a
## handle to a validation function for the arguments.  Such a function must
## return a true value if the arguments are valid and must return a false value
## or issue an error if the arguments are not valid.  In the case of the
## @qcode{"play"} command, the arguments validation function can be written
## as:
##
## @example
## @group
## @@(varargin) nargin == 0 || (nargin == 1 ...
##     && is_positive_integer_scalar(varargin@{1@}))
## @end group
## @end example
##
## This anonymous function returns true if zero or one positive integer scalar
## argument is provided, false otherwise.  Function
## @code{is_positive_integer_scalar} is available in the isthisa toolbox in the
## Atomm source tree.
##
## Let's call the command that shuts down the application @qcode{"quit"}.  It
## won't take any argument, so its argument validation function can be written
## as:
##
## @example
## @group
## @@() true
## @end group
## @end example
##
## This anonymous function does not accept any argument and always returns
## true.
##
## Here's the code for the @code{command_stru_and_default} private function:
##
## @example
## @group
## function [s, default] = command_stru_and_default
##
##     default = 'play';
##     s = struct(...
##         default, struct(...
##             'valid', @@(varargin) nargin == 0 || (nargin == 1 ...
##                 && is_positive_integer_scalar(varargin@{1@})), ...
##             'no_return_value', true), ...
##         'quit', struct(...
##             'valid', @@() true, ...
##             'no_return_value', true));
##
## end
## @end group
## @end example
##
## Note the @qcode{"no_return_value"} fields that have been set to true as the
## two commands don't return anything.
##
## Note also that @qcode{"play"} is the default command for the application.
## This will allow the user to invoke the command without typing its name:
##
## @example
## @group
## mentalsum;
## @end group
## @end example
##
## A minimal @code{alias_stru} private function returns a structure without any
## fields.  This means that the application still has no command aliases.  We
## will add some later.
##
## @example
## @group
## function s = alias_stru
##
##     s = struct();
##
## end
## @end group
## @end example
##
## Finally, here is our minimal @code{run_command} private function:
##
## @example
## @group
## function [clear_req, s, varargout] ...
##         = run_command(c, cargs, cf, o, s1, nout, a)
##
##     clear_req = false;
##     s = s1;
##
##     switch c
##
##         case 'quit'
##             clear_req = true;
##
##         case 'play'
##             1;
##
##     end
##
## end
## @end group
## @end example
##
## It must return a @var{clear_req} output argument (true if the application
## must shut down, false otherwise).  @var{clear_req} is initialized to false
## and set to true only if the invoked command is @qcode{"quit"}.  The name of
## the invoked command is given in the @var{c} input argument.
##
## @code{run_command} must also return a @var{s} output argument.  @var{s} is
## the updated state of the application.  In this minimal version, we return
## the previous application state (input argument @var{s}) as is.  @var{s} is
## initialized to @code{struct()} in the application template.
##
## As the two commands defined so far do not return anything, we don't have to
## assign @var{varargout}.
##
## At this stage, the application can be started up and "operated" with
## statements like:
##
## @example
## @group
## mentalsum;
## mentalsum ('play');
## mentalsum ('play', 10);
## @end group
## @end example
##
## It does nothing particular as the @qcode{"play"} command is not yet
## implemented.
##
## The application can be shut down with this statement:
##
## @example
## @group
## mentalsum ('quit');
## @end group
## @end example
##
## You can check whether the application is up or not using the following
## statement:
##
## @example
## @group
## mislocked ('mentalsum')
## @end group
## @end example
##
## It returns true if the application is up, false otherwise.
##
## @strong{Step 2: Set up the configuration parameters.}
##
## Let's define two configuration parameters for Mental Sum:
##
## @table @asis
## @item @qcode{"operand_digits"}
## Number of digits for the operands (integer from 1 to 8, default value 2).
##
## @item @qcode{"burst_count"}
## Number of additions to evaluate each time the @qcode{"play"} command is
## invoked (positive integer, default value 4).
## @end table
##
## The definition of the configuration parameters takes place in the
## @code{config_stru} private function.  It can be rewritten as:
##
## @example
## @group
## function stru = config_stru
##
##     stru = struct(...
##         'operand_digits', struct(...
##             'default', 2, ...
##             'valid', ...
##                 @@(x) is_positive_integer_scalar(x) && x <= 8), ...
##         'burst_count', struct(...
##             'default', 4, ...
##             'valid', @@is_positive_integer_scalar));
##
## end
## @end group
## @end example
##
## Users who prefer other values than the default values for the configuration
## parameters have two ways to set up different values:
##
## @enumerate
## @item By setting the application data @qcode{"mentalsum"} for handle 0 to a
## structure containing the desired default configuration parameter values.
## Examples:
##
## @example
## @group
## setappdata (0, 'mentalsum', struct ('operand_digits', 3));
## @end group
## @end example
##
## @example
## @group
## setappdata (0, 'mentalsum', ...
##     struct ('operand_digits', 3, 'burst_count', 10));
## @end group
## @end example
##
## Note that in those statements, @qcode{"mentalsum"} is the string returned by
## the @code{app_name} private function.
##
## @item By giving the desired configuration parameter values on the
## @code{mentalsum} start up statement.  Examples:
##
## @example
## @group
## mentalsum ('play', '--', 'operand_digits', 3);
## @end group
## @end example
##
## @example
## @group
## mentalsum ('play', '--', ...
##     'operand_digits', 3, 'burst_count', 10);
## @end group
## @end example
##
## @example
## @group
## mentalsum ('play', '--', ...
##     struct ('operand_digits', 3, 'burst_count', 10));
## @end group
## @end example
##
## Note the use of a "---" argument as a separator between the command
## arguments and the configuration arguments.
## @end enumerate
##
## In the @code{run_command} private function, the configuration parameters are
## available in the @var{cf} input argument (a structure).  The @var{o} input
## argument gives information on the origin of the values.  Let's modify the
## @code{run_command} private function to display the configuration parameters
## and the origin of their values on the application start up:
##
## @example
## @group
## function [clear_req, s, varargout] ...
##     = run_command(c, cargs, cf, o, s1, nout, a)
##
##     clear_req = false;
##     s = s1;
##
##     if ~mislocked('mentalsum') % The application is starting up.
##         fprintf('Configuration parameters:\n');
##         cmp1 = 'Session specific';
##         cmp2 = 'Configuration argument';
##         for cf_param_name = fieldnames(cf)'
##             name = cf_param_name@{1@};
##             if strcmp(o.(name), 'Default')
##                 origin = 'factory defined default value';
##             elseif strncmp(o.(name), cmp1, numel(cmp1))
##                 origin = ['application data "' a '" for handle 0'];
##             elseif strncmp(o.(name), cmp2, numel(cmp2))
##                 origin = ...
##                     'configuration argument on startup statement';
##             end
##             fprintf('  %14s = %8d (%s)\n', name, cf.(name), origin);
##         end
##         fprintf('\n');
##     end
##
##     switch c
##
##         case 'quit'
##             clear_req = true;
##
##         case 'play'
##             1; % Do nothing.
##
##     end
##
## end
## @end group
## @end example
##
## Note the use of the @var{a} input argument which gives the application name
## as returned by the @code{app_name} private function.
##
## @strong{Step 3: Have the application do something and update its state.}
##
## It's now time to implement the @qcode{"play"} command.  We can write it as
## loop calling the @code{add} local function.  This local function prompts the
## user into evaluating an integer addition, get the answer and returns a
## logical scalar (true for a correct answer) and the time the user has taken
## to answer.  It takes the two addition operands as input arguments.
##
## The loop iterates @code{cf.burst_count} times, i.e.@ the number of additions
## that has been set as a configuration parameter.
##
## The loop also updates some fields of the application state structure
## @var{s}.  These fields are:
##
## @table @asis
## @item @qcode{"evaluated"}
## The number of additions evaluated by the user since the application startup.
##
## @item @qcode{"correct"}
## The number of right results obtained by the user since the application
## startup.
##
## @item @qcode{"cum_duration"}
## The cumulative time the user has taken to give the right answers.
## @end table
##
## All of them are initialized to zero when the application starts up.
##
## Another field is initialized on application startup:
## @qcode{"deg_1_poly_coefs"}.  It is the coefficients of the degree 1
## polynomial that must be applied to the output of @code{rand(1)} to get a
## number in the expected range.  It is never updated as it depends only of a
## configuration parameter (@qcode{"operand_digits"}) and configuration
## parameters don't change during application run time.
##
## The @code{draw_op} local function is used to draw the addition operands.
##
## Here is how looks the @code{run_command} private function at this stage:
##
## @example
## @group
## function [clear_req, s, varargout] ...
##     = run_command(c, cargs, cf, o, s1, nout, a)
##
##     clear_req = false;
##     s = s1;
##
##     if ~mislocked('mentalsum') % The application is starting up.
##         fprintf('Configuration parameters:\n');
##         cmp1 = 'Session specific';
##         cmp2 = 'Configuration argument';
##         for cf_param_name = fieldnames(cf)'
##             name = cf_param_name@{1@};
##             if strcmp(o.(name), 'Default')
##                 origin = 'factory defined default value';
##             elseif strncmp(o.(name), cmp1, numel(cmp1))
##                 origin = ['application data "' a '" for handle 0'];
##             elseif strncmp(o.(name), cmp2, numel(cmp2))
##                 origin = ...
##                     'configuration argument on startup statement';
##             end
##             fprintf('  %14s = %8d (%s)\n', name, cf.(name), origin);
##         end
##         fprintf('\n');
##         oD = cf.operand_digits;
##         s.deg_1_poly_coefs = [10^oD - 1 - 10^(oD - 1), 10^(oD - 1)];
##         s.evaluated = 0;
##         s.correct = 0;
##         s.cum_duration = 0;
##     end
##
##     switch c
##
##         case 'quit'
##             clear_req = true;
##
##         case 'play'
##             for k = 1 : cf.burst_count
##                 [correct, duration] = add(...
##                     draw_op(s.deg_1_poly_coefs), ...
##                     draw_op(s.deg_1_poly_coefs));
##                 s.evaluated = s.evaluated + 1;
##                 if correct
##                     s.correct = s.correct + 1;
##                     s.cum_duration = s.cum_duration + duration;
##                 end
##             end
##
##     end
##
## end
##
## # ------------------------------------------------------------------
##
## function [correct, duration] = add(operand1, operand2)
##
##     done = false;
##     loopCount = 0;
##     while ~done
##         if loopCount == 0
##             tic;
##         end
##         answer = strtrim(input(...
##             sprintf('%d + %d = ? ', operand1, operand2), 's'));
##         done = is_matched_by(answer, '^\s*-?[0-9]+\s*$');
##         if ~done
##             fprintf('Please enter a literal integer.\n');
##         else
##             duration = toc;
##         end
##         loopCount = loopCount + 1;
##     end
##     correct = str2double(answer) == operand1 + operand2;
##     if correct
##         fprintf('Correct!\n\n');
##     else
##         fprintf('Wrong!\n\n');
##     end
##
## end
##
##     # - - - - - - - - - - - - - - - - - - - - - - - - - - -
##
## function op = draw_op(deg_1_poly_coefs)
##
##     op = floor(polyval(deg_1_poly_coefs, rand(1)));
##
## end
## @end group
## @end example
##
## Note the use of function @code{is_matched_by} with regular expression
## @qcode{"^\s*-?[0-9]+\s*$"} to check whether the user has entered a literal
## integer or logical value.  If it's not the case, then the user is prompted
## into reentering the answer.  @code{is_matched_by} is available in the
## textandcode toolbox in the Atomm source tree.
##
## @strong{Step 4: Take into account the optional command argument.}
##
## In step 1, we have allowed an optional argument for @qcode{"play"}
## application command.  We haven't made any use of it so far.  It is supposed
## to supersede the @qcode{"operand_digits"} configuration parameter.
##
## In the @code{run_command} private function, the command arguments are
## available in the @var{cargs} cell array.  In the case of the @qcode{"play"}
## application command, @var{cargs} is an empty cell array if the user has not
## provided the optional argument, or a cell array of length 1 in the opposite
## case.
##
## It is enough to substitute the line @code{for k = 1 : cf.burst_count} with:
##
## @example
## @group
##             if isempty(cargs)
##                 n = cf.burst_count;
##             else
##                 n = cargs@{1@};
##             end
##             for k = 1 : n
## @end group
## @end example
##
## @strong{Step 5: Add a command to show the game result.}
##
## At this stage, Mental Sum is still not able to show how the player did.
## Let's fill that gap by adding a new command to the application, called
## @qcode{"result"}.  It will show how many additions the player evaluated, how
## many right answers he gave and the mean time he took to give a right answer.
##
## The @qcode{"result"} application command won't take any arguments and return
## the three displayed values (number of evaluated additions, number of right
## answers, mean time) in that order as output arguments.
##
## Adding the @qcode{"result"} application command implies an update of the
## @qcode{command_stru_and_default} private function:
##
## @example
## @group
## function [s, default] = command_stru_and_default
##
##     default = 'play';
##     s = struct(...
##         default, struct(...
##             'valid', @@(varargin) nargin == 0 || (nargin == 1 ...
##                 && is_positive_integer_scalar(varargin@{1@})), ...
##             'no_return_value', true), ...
##         'result', struct(...
##             'valid', @@() true, ...
##             'no_return_value', false), ...
##         'quit', struct(...
##             'valid', @@() true, ...
##             'no_return_value', true));
##
## end
## @end group
## @end example
##
## Note the false value of the @qcode{"no_return_value"} field for the new
## @qcode{"result"} application command, implied by the fact that
## @qcode{"no_return_value"} has output arguments.
##
## Of course the @code{run_command} private function must also be updated.  A
## new case in the @code{switch} construct is enough.  All is needed is to
## assign the three output values to the @var{varargout} cell array and display
## them with @code{fprintf} statements.  An error statement is used to stop the
## command if no additions have been evaluated (i.e.@ if the @qcode{"play"}
## command has not been run prior to the @qcode{"result"} command).
##
## @example
## @group
##         case 'result'
##             if s.evaluated == 0
##                 error('Please run the "play" command first');
##             end
##             varargout = @{...
##                 s.evaluated, ...
##                 s.correct, ...
##                 s.cum_duration / s.correct@};
##             fprintf(...
##                 '%d Additions evaluated, %d correct answers.\n', ...
##                 varargout@{1@}, varargout@{2@});
##             fprintf(...
##                 '%.2fs to give a right answer (mean time).\n', ...
##                 varargout@{3@});
## @end group
## @end example
##
## Example usage of the @qcode{"result"} application command:
##
## @example
## @group
## [evaluated, correct, meanTime] = mentalsum ('result');
## @end group
## @end example
##
## Of course, we could have handled the case where the number of correct
## answers is zero better.  "Inf" is displayed and returned if the number of
## correct answers is zero better.
##
## @strong{Step 6: Define command aliases.}
##
## This step consists in defining some command aliases.  This is not mandatory
## and it won't make the application capable of doing anything new but it might
## make the life of the users easier.
##
## For example, command aliases allow to define shorter names for the commands.
## Users may appreciate to be allowed to type @code{mentalsum ('p', 10);}
## instead of @code{mentalsum ('play', 10);}.
##
## Aliases can also include one or more command arguments.  For example, you
## can define a @qcode{"p1"} alias for the @qcode{"play"} command with the
## optional argument set to 1.  This will allow the user to type
## @code{mentalsum ('p1');} instead of @code{mentalsum ('play', 1);}.
##
## Command aliases are defined in the @code{alias_stru} private function. Let's
## modify our @code{alias_stru} private function so that short names are
## defined for all the commands and a @qcode{"p1"} alias is defined for the
## @qcode{"play"} command with the optional argument set to 1:
##
## @example
## @group
## function s = alias_stru
##
##     s = struct(...
##         'p', @{@{'play'@}@}, ...
##         'r', @{@{'result'@}@}, ...
##         'q', @{@{'quit'@}@}, ...
##         'p1', @{@{'play', 1@}@});
##
## end
## @end group
## @end example
##
## @strong{Step 7: Ignore unused arguments in @code{run_command}.}
##
## This is the final step in the writing of Mental Sum: ignoring the input
## arguments of the @code{run_command} private function that are unused.
##
## @var{nout} (i.e.@ the number of output arguments specified by the user when
## invoking the application) is not used.  It can be substituted with the tilde
## (~) symbol.  This prevents code analyzers like Matlab's @code{checkcode}
## from complaining about an unused argument.
##
## So here is the new signature of @code{run_command}:
##
## @example
## @group
## function [clear_req, s, varargout] = run_command(...
##     c, cargs, cf, o, s1, ~, a)
## @end group
## @end example
##
## @seealso{checkmtree, isvarname, mislocked, outman, toolman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = mentalsum(varargin)

    persistent name dConf cfLocked config configOrigin cmd cmdDflt alias state;

    if isempty(cfLocked)

        name = app_name;
        # app_name is an application specific private function.

        [cmd, cmdDflt] = command_stru_and_default;
        # command_stru_and_default is an application specific private function.

        check_command_stru_and_default(cmd, cmdDflt);

        alias = alias_stru;
        # alias_stru is an application specific private function.

        check_alias_stru(cmd, alias);

        dConf = config_stru;
        # config_stru is an application specific private function.

        [config, configOrigin] = default_config(dConf, name);

        cfLocked = false;

        state = struct();
    endif

    try
        # Perform user argument checking, which may throw an error.

        arg = command_alias_expansion(cmdDflt, alias, varargin{:});
        check_command_name(cmd, arg{:});
        [cmdName, cmdArg, configArgs] = command_and_config_args(arg, cmd);
        [config, configOrigin] = apply_config_args(...
            name, dConf, config, configOrigin, cfLocked, configArgs{:});
        check_command_args(cmd, cmdName, cmdArg{:});
    catch e
        if ~cfLocked
            # Reset application persistent variables, which will allow the next
            # configuration attempt to be successful.
            clear(mfilename);
        endif
        rethrow(e);
    end_try_catch

    if cmd.(cmdName).no_return_value
        minCmdOutputArgCount = 0;
    else
        minCmdOutputArgCount = 1;
    endif
    CmdOutputArgCount = max([minCmdOutputArgCount nargout]);
    try
        [clearAppRequested, state, varargout{1 : CmdOutputArgCount}] ...
            = run_command(cmdName, cmdArg, config, configOrigin, state, ...
                nargout, name);
        commandError = false;
    catch e
        clearAppRequested = ~cfLocked;
        commandError = true;
    end_try_catch

    cfLocked = true;

    if clearAppRequested
        munlock;
        clear(mfilename);
    else
        mlock;
    endif

    if commandError
        rethrow(e);
    endif

endfunction

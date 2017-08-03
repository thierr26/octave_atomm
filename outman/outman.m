## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} outman ('disp', @var{caller_id}, @var{x})
## @deftypefnx {Function File} outman ('dispf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('printf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('infof', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('warningf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('errorf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('logf', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} outman ('logtimef', @var{caller_id}, @var{@
## template}, ...)
## @deftypefnx {Function File} {@
## @var{progress_indicator_id} =} outman ('init_progress', @var{@
## caller_id}, @var{start_position}, @var{finish_position}, @var{@
## task_description_string})
## @deftypefnx {Function File} outman ('update_progress', @var{@
## caller_id}, @var{progress_indicator_id}, @var{new_position})
## @deftypefnx {Function File} outman ('update_progress', @var{@
## caller_id}, @var{progress_indicator_id}, @var{start_position}, @var{@
## finish_position}, @var{new_position})
## @deftypefnx {Function File} {@var{@
## duration} =} outman ('terminate_progress', @var{caller_id}, @var{@
## progress_indicator_id})
## @deftypefnx {Function File} outman ('cancel_progress', @var{@
## caller_id}, @var{progress_indicator_id})
## @deftypefnx {Function File} outman ('shift_progress', @var{@
## caller_id}, @var{progress_indicator_id}, @var{fractional_shift})
## @deftypefnx {Function File} {@var{@
## config} =} outman ('get_config', @var{caller_id})
## @deftypefnx {Function File} {@var{@
## config_origin} =} outman ('get_config_origin', @var{caller_id})
## @deftypefnx {Function File} {@var{@
## hmi_variant} =} outman ('get_hmi_variant', @var{caller_id})
## @deftypefnx {Function File} {@var{@
## log_file_name} =} outman ('get_log_file_name', @var{caller_id})
## @deftypefnx {Function File} outman ('disconnect', @var{caller_id})
##
## Display and log outputs, manage progress indicators.
##
## @strong{Use Outman as a central messaging system if possible.}
##
## The name Outman is the contraction of the words "output" and "manager".
## Outman is an application aimed at being used as a central message displaying
## and logging system and as a central progress indicator management system.
##
## Outman is designed based on the assumption that for any function or script
## using it, every subprogram being called directly or indirectly also uses it
## for displaying messages and for managing progress indicators.  If it is not
## the case, then Outman's progress indicators may not be displayed properly,
## at least if Outman is configured to display to the command window.
##
## If you really have to use subprograms that display messages to the command
## window but do it without using Outman, then configure Outman so that the
## progress indicators are not displayed to the command window but to a
## progress file.  Outman progress files and Outman configuration are topics
## covered later in this documentation.
##
## @strong{Try @code{demo_outman}, the demonstration program for Outman.}
##
## If you haven't altered Outman's default configuration, then issuing a
## @code{demo_outman} command demonstrates what Outman can do.  In Matlab for
## Windows, this will not be very visually interesting because the display of
## the progress indicators has been disabled due to some unclear issues with
## the Matlab Java desktop.  To run @code{demo_outman} with the display of the
## progress indicators enabled, use this command instead:
##
## @example
## @group
## demo_outman('hmi_variant', 'command_window')
## @end group
## @end example
##
## This command causes @code{demo_outman} to use Outman with a customized
## configuration.  Outman's configuration parameter @qcode{"hmi_variant"} is
## set to "command_window" (which means that messages and progress indicators
## are displayed to the command window) whereas the default value for
## @qcode{"hmi_variant"} in Matlab for Windows is "command_window_no_progress"
## (which means that the progress indicators are not displayed).
##
## Note that there is another condition that must be fulfilled so that the
## progress indicators are displayed in Matlab.  This condition is that the
## Java Desktop is running.  You can check that this condition is fulfilled by
## issuing the following command:  If it returns true, then the Java Desktop is
## running.
##
## @example
## @group
## usejava('desktop')
## @end group
## @end example
##
## @strong{Connect and get a caller ID, issue Outman commands, disconnect.}
##
## To be able to issue some Outman commands to display or log messages or to
## operate progress indicators, you must have connected to Outman and got an
## "Outman caller ID" which is a number that identifies you (well, the code you
## write) as an Outman user and that must be provided in every call to
## @code{outman}.
##
## To get a caller ID, simply call @code{outman_connect_and_config_if_master}.
## After that, you can issue as many Outman commands as you need and when done
## disconnect from Outman using Outman's @qcode{"disconnect"} command.
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## ... % You're business code here.
## outman('printf', @var{callerID}, 'A message.');
## ... % You're business code here.
## outman('printf', @var{callerID}, 'An other message.');
## ... % You're business code here.
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## This caller ID thing allows Outman to know who is its "master caller".  The
## master caller is the first that connects to Outman and starts it up.  When
## the master caller issues its @code{outman('disconnect', ...)} statement
## Outman knows that there are no more callers left and shuts down.
##
## The @code{outman('disconnect', ...)} statements are very important and must
## not be omitted.  If the master caller does not disconnect and Outman does
## not shut down, then the next caller which should have been considered a
## master caller won't be considered as such and will not be able to configure
## Outman to its need.  Indeed, Outman's configuration can be tuned by
## providing arguments when calling @code{outman_connect_and_config_if_master}.
## Those arguments are ignored, unless when it is the master caller issuing the
## call.  More details about Outman configuration later in this documentation.
##
## The functions that can issue errors require a lot of attention.  Make sure
## that an error condition cannot cause the function to be exited without
## executing the @code{outman('disconnect', ...)} statement.
##
## One possibility is to disconnect from Outman before reaching the line of
## code that may issue an error and reconnect after if needed:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## ...
## outman('disconnect', @var{callerID});
## ... % Code that may issue an error
## @var{callerID} = outman_connect_and_config_if_master;
## ...
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## Another idea is to catch the error, disconnect from Outman and then rethrow
## the error:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## ...
## try
##     ... % Code that may issue an error
## catch @var{e}
##     outman('disconnect', @var{callerID});
##     rethrow(@var{e});
## end
## ...
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## If at some point (while debugging some M-files for example) you end up with
## Outman not shut down and you have lost the master caller ID, you can force
## Outman to shut down with the @code{outman_kill} function:
##
## @example
## @group
## outman_kill ();
## @end group
## @end example
##
## If you need to know whether Outman has been shut down or not, issue this
## statement.  A true return value means that Outman has not been shut down.
##
## @example
## @group
## mislocked ('outman')
## @end group
## @end example
##
## Now that the importance of the @qcode{"disconnect"} command has been clearly
## stated, Let's have a look to the other Outman commands.  They can be divided
## into three families:
##
## @itemize @bullet
## @item
## Message displaying and logging commands.
##
## @item
## Progress indicator management commands.
##
## @item
## Configuration getters.
## @end itemize
##
## The message displaying and logging commands are:
##
## @table @asis
## @item @qcode{"disp"}
## Display the value of a variable or expression.  The output is identical to
## the output produced by the @code{disp} built-in function.
##
## Example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## @var{any_variable} = rand(2, 3);
## outman('disp', @var{callerID}, @var{any_variable});
## outman('disp', @var{callerID}, pi / 2);
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## @item @qcode{"dispf"}
## Display optional arguments under the control of the template string (like
## @code{fprintf}).  Note that a new line is automatically added.  No need to
## put one at the end of the template string.
##
## Example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## outman('dispf', @var{callerID}, 'pi is approximately: %f', pi);
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## @item @qcode{"printf"}
## Identical to command @qcode{"dispf"} except that the output is @emph{also}
## written to the log file (if one has been specified in Outman's configuration
## via configuration parameters @qcode{"logdir"} and @qcode{"logname"}).
##
## Example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## outman('printf', @var{callerID}, 'pi is approximately: %f', pi);
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## @item @qcode{"infof"}
## Identical to command @qcode{"printf"} except that the output is prefixed
## with (by default) "(I) ".  The prefix is actually defined via configuration
## parameter @qcode{"info_leader"}.
##
## Example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## outman('infof', @var{callerID}, 'pi is approximately: %f', pi);
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## @item @qcode{"warningf"}
## Identical to command @qcode{"printf"} except that the output is prefixed
## with (by default) "(W) ".  The prefix is actually defined via configuration
## parameter @qcode{"warning_leader"}.
##
## Example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## outman('warningf', @var{callerID}, 'pi is approximately: %f', pi);
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## @item @qcode{"errorf"}
## Identical to command @qcode{"printf"} except that the output is prefixed
## with (by default) "(E) ".  The prefix is actually defined via configuration
## parameter @qcode{"error_leader"}.
##
## Example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## outman('errorf', @var{callerID}, 'pi is approximately: %f', pi);
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## @item @qcode{"logf"}
## Identical to command @qcode{"printf"} except that the output is not
## displayed but written @emph{to the log file only} (if one has been specified
## in Outman's configuration via configuration parameters @qcode{"logdir"} and
## @qcode{"logname"}).
##
## Example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master;
## outman('logf', @var{callerID}, 'pi is approximately: %f', pi);
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## @item @qcode{"logtimef"}
## Identical to command @qcode{"logf"} except that the output is prefixed with
## a timestamp.
##
## @example
## @group
## outman('logtimef', @var{callerID}, 'pi is approximately: %f', pi);
## outman('logtimef', @var{callerID}, 'pi is approximately: %f', pi);
## outman('disconnect', @var{callerID});
## @end group
## @end example
## @end table
##
## The progress indicator management commands are:
##
## @itemize @bullet
## @item @qcode{"init_progress"}
##
## @item @qcode{"update_progress"}
##
## @item @qcode{"terminate_progress"}
##
## @item @qcode{"shift_progress"}
##
## @item @qcode{"cancel_progress"}
## @end itemize
##
## Let's illustrate the use of the first three commands with an example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master(...
##     'hmi_variant', 'command_window'); % Make sure that the
##                                       % display of the
##                                       % progress indicators
##                                       % is enabled.
## start = -40;
## finish = 200;
## @var{progressID} = outman('init_progress', @var{callerID}, ...
##     start, finish, 'Counting...');
## for @var{k} = start : finish
##     pause(0.009);
##     outman('update_progress', @var{callerID}, @var{progressID}, @var{k});
## end
## duration = outman('terminate_progress', ...
##     @var{callerID}, @var{progressID});
## outman('dispf', @var{callerID}, ...
##     'Counting task lasted %s.', duration_str(duration));
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## The @qcode{"init_progress"} command is used to initialize a progress
## indicator.  It takes as arguments the caller ID (like every Outman command),
## a start and a finish position (in arbitrary unit) as well as a string
## describing the task being executed.  It returns a progress ID which
## identifies the progress indicator and needs to be provided as argument to
## every other Outman command used to operate this progress indicator.
##
## The @qcode{"update_progress"} command is used to inform Outman of the
## progress of the task.  It takes as arguments the caller and progress IDs as
## well as the current progress value, in the same unit as the start and finish
## positions provided to the @qcode{"init_progress"} command.
##
## The @qcode{"terminate_progress"} command is used to notify Outman of the
## fact that the task is done.  It takes as arguments the caller and progress
## IDs.  It returns the elapsed time between the initialization of the progress
## indicator and its termination.  This time is in days and can be converted to
## a string using the @code{duration_str} function.
##
## In the case where the start and finish positions need to be adjusted during
## the task, provide the new start and finish positions to the
## @qcode{"update_progress"} command before the current progress argument, like
## in the following example:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master(...
##     'hmi_variant', 'command_window');
## start = -40;
## finish = 200;
## @var{progressID} = outman('init_progress', @var{callerID}, ...
##     start, finish, 'Counting...');
## newFinish = finish;
## @var{k} = start;
## while @var{k} < newFinish
##     newFinish = newFinish - 0.25;
##     @var{k} = @var{k} + 1;
##     pause(0.009);
##     outman('update_progress', @var{callerID}, @var{progressID}, ...
##         start, newFinish, @var{k});
## end
## duration = outman('terminate_progress', ...
##     @var{callerID}, @var{progressID});
## outman('dispf', @var{callerID}, ...
##     'Counting task lasted %s.', duration_str(duration));
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## An unlimited number of progress indicators can be initialized.  Outman
## displays only the topmost progress indicators.  The number of progress
## indicators displayed is tunable via the @qcode{progress_max_count}
## configuration parameter.  It defaults to 3.  Note that if the command window
## is too narrow to display the progress indicators in their "normal" format
## Outman switches to a very short format instead (a single percentage number).
## The format of the progress indicators is configurable via the
## @qcode{"progress_format"} and @qcode{"progress_short_format"} configuration
## parameters.
##
## The following example is a case of having up to 2 progress indicators at the
## same time:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master(...
##     'hmi_variant', 'command_window');
## @var{progressID1} = outman('init_progress', @var{callerID}, ...
##     1, 10, 'First');
## for @var{k} = 1 : 10
##     @var{progressID2} = outman('init_progress', @var{callerID}, ...
##         1, 100, 'Second');
##     for @var{kk} = 1 : 100
##         pause(0.035);
##         outman('update_progress', ...
##             @var{callerID}, @var{progressID2}, @var{kk} + 1);
##     end
##     duration = outman('terminate_progress', ...
##         @var{callerID}, @var{progressID2});
##     pause(0.015);
##     outman('update_progress', @var{callerID}, @var{progressID1}, ...
##         @var{k} + 1);
## end
## @var{duration} = outman('terminate_progress', ...
##     @var{callerID}, @var{progressID1});
## outman('dispf', @var{callerID}, ...
##     'Counting task lasted %s.', duration_str(@var{duration}));
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## When running the example above, we see that the first progress indicator is
## frozen while the second one "moves".  The @qcode{"shift_progress"} command
## can be used as a way to animate the first progress indicator.  Place a
## @code{outman('shift_progress', @var{callerID}, @var{progressID1}, ...)}
## statement just before the
## @code{outman('update_progress', @var{callerID}, @var{progressID2}, ...)}
## statement.  The @qcode{"shift_progress"} command does not update the
## display, that's why it is recommended to place it just before a
## @qcode{"update_progress"} command (which updates the display).  The last
## argument to the @qcode{"shift_progress"} command is a fractional shift (for
## example use a value of 0.01 to shift the progress indicator by one percent).
## You have to choose the shift value on a case by case basis.  It may be
## difficult in some cases.  Of course in our example it is easy enough.  The
## complete task is made of 1000 iterations of the inner loop.  A shift value
## of 0.001 on every iteration of the inner loop should be OK.
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master(...
##     'hmi_variant', 'command_window');
## @var{progressID1} = outman('init_progress', @var{callerID}, ...
##     1, 10, 'First');
## for @var{k} = 1 : 10
##     @var{progressID2} = outman('init_progress', @var{callerID}, ...
##         1, 100, 'Second');
##     for @var{kk} = 1 : 100
##         pause(0.035);
##         outman('shift_progress', ...
##             @var{callerID}, @var{progressID1}, 0.001);
##         outman('update_progress', ...
##             @var{callerID}, @var{progressID2}, @var{kk} + 1);
##     end
##     duration = outman('terminate_progress', ...
##         @var{callerID}, @var{progressID2});
##     pause(0.015);
##     outman('update_progress', @var{callerID}, @var{progressID1}, ...
##         @var{k} + 1);
## end
## @var{duration} = outman('terminate_progress', ...
##     @var{callerID}, @var{progressID1});
## outman('dispf', @var{callerID}, ...
##     'Counting task lasted %s.', duration_str(@var{duration}));
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## Of course calling the @qcode{"update_progress"} and @qcode{"shift_progress"}
## commands on each iteration may not be a very good idea as far as the
## performance of the code is concerned.  In our example, calling them once
## every 20 iterations of the inner loop may be enough.  We can do that by
## adding a @code{mod(@var{kk}, 20) == 0} condition.  Here again, it is a
## choice to make on a case by case basis.
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master(...
##     'hmi_variant', 'command_window');
## @var{progressID1} = outman('init_progress', @var{callerID}, ...
##     1, 10, 'First');
## for @var{k} = 1 : 10
##     @var{progressID2} = outman('init_progress', @var{callerID}, ...
##         1, 100, 'Second');
##     for @var{kk} = 1 : 100
##         pause(0.035);
##         if mod(@var{kk}, 20) == 0
##             outman('shift_progress', ...
##                 @var{callerID}, @var{progressID1}, 0.001);
##             outman('update_progress', ...
##                 @var{callerID}, @var{progressID2}, @var{kk} + 1);
##         end
##     end
##     duration = outman('terminate_progress', ...
##         @var{callerID}, @var{progressID2});
##     pause(0.015);
##     outman('update_progress', @var{callerID}, @var{progressID1}, ...
##         @var{k} + 1);
## end
## @var{duration} = outman('terminate_progress', ...
##     @var{callerID}, @var{progressID1});
## outman('dispf', @var{callerID}, ...
##     'Counting task lasted %s.', duration_str(@var{duration}));
## outman('disconnect', @var{callerID});
## @end group
## @end example
##
## The @qcode{"cancel_progress"} command is aimed at being used instead of the
## @qcode{"terminate_progress"} command in the cases where the program cannot
## complete the task (e.g.@ in the case where an error as occurred and the task
## must be interrupted).  The @qcode{"cancel_progress"} command takes the
## caller and progress IDs as arguments and does not return anything.
##
## Earlier in this documentation, the importance of the
## @code{outman('disconnect', ...)} statements has been explained.  The
## @code{outman('terminate_progress', ...)} and
## @code{outman('cancel_progress', ...)} statements are also very important and
## require the same attention.
##
## The last family of outman commands is the family of the configuration
## getters.  Here are these commands:
##
## @table @asis
## @item @qcode{"get_config"}
## Similar to Toolman's or Checkmtree's @qcode{"get_config"} command except
## that the caller ID must be provided as argument.
##
## @item @qcode{"get_config_origin"}
## Similar to Toolman's or Checkmtree's @qcode{"get_config_origin"} command
## except that the caller ID must be provided as argument.
##
## @item @qcode{"get_hmi_variant"}
## Get the value of Outman's "hmi_variant" configuration parameter.  The caller
## ID must be provided as argument.
##
## @item @qcode{"get_log_file_name"}
## Get the name of Outman's log file (empty string if no log file configured).
## @end table
##
## @strong{Configure Outman to your need.}
##
## The behaviour of Outman can be customized by the master caller.  That's what
## has been done in some of the examples above with statements like:
##
## @example
## @group
## outman_connect_and_config_if_master(...
##     'hmi_variant', 'command_window');
## @end group
## @end example
##
## If this is the master caller issuing this statement, then Outman starts up
## with its @qcode{"hmi_variant"} configuration parameter set to
## "command_window".  If this is not the master caller issuing the statement,
## then the arguments to @code{outman_connect_and_config_if_master} are
## ignored.
##
## Here is another example of configuration customization, with the
## specification of a log file:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master(...
##     'logdir', 'path/to/log', 'logname', 'my_log.log');
## @end group
## @end example
##
## An alternative is to provide the configuration parameters as a structure
## instead of name-value pairs:
##
## @example
## @group
## @var{callerID} = outman_connect_and_config_if_master(...
##     struct(logdir', 'path/to/log', 'logname', 'my_log.log'));
## @end group
## @end example
##
## Note also that you can alter Outman's default configuration using a
## @code{setappdata (0, 'outman', ...)} statement.  Toolman has an identical
## mechanism for default configuration customization.  Please see the
## documentation for Toolman (issue a @code{help toolman} command to read it).
##
## Here is the complete list of Outman's configuration parameters, starting
## with the ones that may interest Outman's users the most:
##
## @table @asis
## @item @qcode{"logdir"}
## Path to the log file if any (i.e.@ if the @qcode{"logname"} configuration
## parameter is not empty).  Defaults to the user home directory (as returned
## by function @code{home_dir}).
##
## @item @qcode{"logname"}
## Log file name.  An empty string means "no log file".  Defaults to the empty
## string.
##
## @item @qcode{"hmi_variant"}
## One of:
##
## @table @asis
## @item "command_window"
## Outman displays messages and progress indicators to the command window.
## Note this particular case though:  When run by Matlab and if the following
## statement returns false, then the progress indicators are not displayed.
##
## @example
## @group
## usejava('desktop')
## @end group
## @end example
##
## @item "command_window_no_progress"
## Same as "command_window" except that Outman does not display the progress
## indicators.
##
## @item "log_file_only_if_any"
## Outman does not display anything.
## @end table
##
## Defaults to "command_window" except when run by Matlab for windows.  In this
## case, defaults to "command_window_no_progress".
##
## Note that the @qcode{"hmi_variant"} configuration parameter does not have
## any impact on what is written to the log file or not.
##
## @item @qcode{"progress_file_name"}
## Name of the progress indicator file, which is a one line text file to which
## Outman writes progress indication.  An empty string means "no progress
## indicator file".  Defaults to the empty string.
##
## A progress indicator file is useful when the value "command_window" for the
## @qcode{"hmi_variant"} configuration parameter is not usable for any reason.
## It is a way of not leaving the users of your programs without any progress
## indication.  To actually see the progress indication written to the progress
## indicator file, the user has to use an external program.
##
## In a Linux environment, the user can issue a command like the following in a
## terminal:
##
## @example
## @group
## watch cat path/to/progress_indicator_file
## @end group
## @end example
##
## In a Windows environment, the user can use the looptype batch script at a
## command line prompt:
##
## @example
## @group
## looptype path/to/progress_indicator_file
## @end group
## @end example
##
## The looptype batch script is free software and is available on GitHub:
## @uref{https://github.com/thierr26/looptype}
##
## @item @qcode{"progress_format"}
## Format string for the progress indicators (long format).  Defaults to
## "[ %msg %percent%% ]".
##
## In this format string, "%msg" is a placeholder for the task description
## (i.e.@ the string provided as last argument to the @qcode{"init_progress"}
## Outman command) and "%percent" is a placeholder for the progress value in
## percent.  The double percent sign ("%%") causes a single percent sign to be
## displayed (like in a @code{fprintf} template string).
##
## @item @qcode{"progress_short_format"}
## Format string for the progress indicators (short format, used when the
## command window is narrower than the progress indication in its long format).
## Defaults to "[ %percent%% ]".
##
## The allowed placeholders are the same as for @qcode{"progress_format"}.
##
## @item @qcode{"progress_display_duration"}
## Logical flag.  When true, the task duration is displayed (appended to the
## progress indication in its long format).  Defaults to true.
##
## @item @qcode{"progress_max_count"}
## Maximum number of progress indicators displayed at the same time.  Defaults
## to 3.
##
## @item @qcode{"progress_update_rate"}
## Maximum update rate (in Hz) for the progress indicators.  Defaults to 2,
## must be in the [0.1, 10.0] range.
##
## @item @qcode{"progress_file_update_rate"}
## Maximum update rate (in Hz) for the progress file indicator.  Defaults to
## 0.33, must be in the [0.001, 0.5] range.
##
## @item @qcode{"log_close_ms_delay"}
## Millisecond delay after which the log file is closed if no writing is done
## to the log file.  Defaults to 3000ms.
##
## Please note the following points:
## @itemize @bullet
## @item
## The log file may be left open much longer than @qcode{"log_close_ms_delay"}
## if no Outman command is issued for a long time.
##
## @item
## When shutting down (on a @code{outman('disconnect', ...)} statement issued
## by the caller master), the log file is closed whatever the value of
## @qcode{"log_close_ms_delay"}.
## @end itemize
##
## @item @qcode{"log_rotation_megabyte_threshold"}
## Size threshold (in megabyte) for the rotation of the log file.  Defaults to
## 10.
##
## Please see the documentation for function @code{rotate_file} for details
## about what a file rotation is.
##
## @item @qcode{"info_leader"}
## Prefix used by the @qcode{"infof"} command.  Defaults to "(I)" plus a space
## character.
##
## @item @qcode{"warning_leader"}
## Prefix used by the @qcode{"warningf"} command.  Defaults to "(W)" plus a
## space character.
##
## @item @qcode{"error_leader"}
## Prefix used by the @qcode{"errorf"} command.  Defaults to "(E)" plus a space
## character.
##
## @item @qcode{"min_width_for_word_wrapping"}
## Command window width thresholds (in characters) to apply word wrapping in
## "dispf", "printf", "infof", "errorf", "printf" commands.  Defaults to 50.
## If the command window is narrower than this threshold, then no word wrapping
## occurs.  Choosing a very high value is a way of disabling word wrapping.
##
## @item @qcode{"progress_immediate_reshow"}
## Logical flag.  When true, the progress indicators are immediately
## re-displayed in the command window after a message displaying command.
## Defaults to true when this is Octave running Outman, defaults to false when
## this Matlab running Outman.
## @end table
##
## @seealso{checkmtree, demo_outman, disp, duration_str, fprintf, home_dir,
## mislocked, outman_connect_and_config_if_master, outman_kill, rotate_file,
## toolman}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function varargout = outman(varargin)

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
            # Emptying cfLocked makes it possible for the next configuration
            # attempt to be successful.
            cfLocked = [];
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
        cfLocked = [];
    else
        mlock;
    endif

    if commandError
        rethrow(e);
    endif

endfunction

-module(calculator_with_links).
-compile([export_all]).

run_kill_example() ->
  process_flag(trap_exit, true),
  io:format("I am the process ~p and I'm able to know when any linked process terminates...~n~n", [self()]),
  timer:sleep(2000),
  ChildFunPid = spawn_link(?MODULE, child_fun, [120]),
  io:format("The process ~p has been created and have the following links:~n", [ChildFunPid]),
  io:format("~p~n~n", [process_info(ChildFunPid, links)]),
  spawn(fun() ->
            io:format("I am the process ~p. I'm here to kill the process ~p.~n", [self(), ChildFunPid]),
            timer:sleep(1500),
            io:format("~p will be killed~n~n", [ChildFunPid]),
            exit(ChildFunPid, kill)
        end),

  receive
    {'EXIT', Pid, killed} ->
      io:format("The process ~p was killed~n", [Pid])
  end,
  ok.

run_fake_monitor() ->
  process_flag(trap_exit, true),
  [spawn_link(?MODULE, child_wrong, [nil, fail]) || 
    _ <- lists:seq(1, 5)],
  ChildFunPid = spawn_link(?MODULE, child_fun, [120]),
  spawn(fun() ->
            timer:sleep(10000),
            io:format("~p will be killed~n~n", [ChildFunPid]),
            exit(ChildFunPid, kill)
        end),
  get_and_treat_messages(),
  ok.

run() ->
  start(),
  get_and_treat_messages().

start() ->
  process_flag(trap_exit, true),
  Pids = [spawn_link(?MODULE, child_fun, [60]) || 
    _ <- lists:seq(1, 5)],
  FailPids = [spawn_link(?MODULE, child_wrong, [nil, fail]) || 
    _ <- lists:seq(1, 5)],

  spawn(fun() ->
            timer:sleep(10000),
            P = hd(Pids),
            io:format("~p will be killed~n~n", [P]),
            exit(P, kill)
        end),

  FailPids ++ Pids.

get_and_treat_messages() ->
  receive
    {'EXIT', Pid, killed} ->
      io:format("The process ~p was killed~n", [Pid]),
      get_and_treat_messages();

    {'EXIT', Pid, normal} ->
      io:format("The process ~p has finished~n", [Pid]),
      get_and_treat_messages();

    {'EXIT', Pid, ErrorReason} ->
      io:format("An error happened with the process (~p) // Reason: ~p~n", [Pid, ErrorReason]),
      NewPid = spawn_link(?MODULE, child_wrong, [Pid, not_fail]),
      io:format("Fake monitor: Let's get it up differently (new pid ~p).~n~n", [NewPid]),
      get_and_treat_messages()

  after
    60000 -> timeout
  end.

getting_messages() ->
  receive
    {'EXIT', _Pid, _Reason} = Any ->
      io:format("Receive any ~p~n", [Any]),
      getting_messages()
  after 60000 ->
    io:format("Timeout~n")
  end.

child_wrong(OlderPid, not_fail) ->
  io:format("I failed as ~p but I'll not fail this time (~p)~n", [OlderPid, self()]),
  timer:sleep(5000);
child_wrong(_, fail) ->
  timer:sleep(2000),
  io:format("I ~p will try to do my job~n", [self()]),
  timer:sleep(10000),
  error(something_went_wrong).

child_fun(0) -> io:format("I ~p am dying~n", [self()]);
child_fun(N) when N rem 5 == 0 ->
  % io:format("Process ~p will die in ~p seconds~n", [self(), N]),
  timer:sleep(1000),
  child_fun(N-1);
child_fun(N) ->
  timer:sleep(1000),
  child_fun(N-1).

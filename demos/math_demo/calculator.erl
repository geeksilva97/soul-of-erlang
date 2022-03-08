% This is my naive worker
-module(calculator).
-compile([export_all]).

run() ->
  Pid = start(),
  Numbers = [10, 100, 1000, 1000000, 10000000, 99999999, 13],
  lists:map(fun(N) -> Pid ! N end, Numbers),
  Pid.
  
start() ->
  spawn(?MODULE, loop, [self()]). 

calc_work(_, 13) ->
  error("Something went wrong");
calc_work(ParentPid, N) ->
  io:format("The process ~p started computing the sum from 1 to ~p~n", [self(), N]),
  Result = calc(N),
  ParentPid ! {self(), {result, Result}}.

calc(N) when is_number(N) ->
  Sequence = lists:seq(1, N),
  do_calc(Sequence, 0).

do_calc([], Acc) -> Acc;
do_calc([H|T], Acc) -> do_calc(T, H + Acc).

test(ParentPid) ->
  io:fwrite("I am a new process with Pid: ~p and my parent has the Pid ~p\n", [self(), ParentPid]),
  ParentPid ! {test_fn, "I am the test()"}.

loop(Parent) ->
  process_flag(trap_exit, true),
  receive 
    exit -> exit(normal);
    N when is_number(N) ->
      WorkerPid = spawn(?MODULE, calc_work, [self(), N]),
      Parent ! {worker_info, WorkerPid, erlang:process_info(WorkerPid)},
      loop(Parent);

    {WorkerPid, {result, Result}} ->
      io:format("The process ~p has been executed with the result ~p~n", [WorkerPid, Result]),
      loop(Parent);

    Any ->
      io:format("Unexpected Result: ~p~n", [Any]),
      loop(Parent)
  end.

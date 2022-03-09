% This is my naive worker
-module(calculator).
-compile([export_all]).

run() ->
  Pid = start(),
  Numbers = [9999999, 13, 999999, 10, 100, 1000, 10000, 10000, 99999999],
  [Pid ! {do_calc, Number} || Number <- Numbers],
  Pid.
  
start() ->
  process_flag(trap_exit, true),
  Pid = spawn(?MODULE, loop, [self(), dict:new()]),
  register(?MODULE, Pid),
  Pid.

see_workers() -> ?MODULE ! see_workers.
inspect_workers() -> ?MODULE ! inspect_workers.
stop() -> ?MODULE ! exit.

calc_work(ParentPid, 13) ->
  ParentPid ! {error, {self(), "Something went wrong"}};
  % error({error, {self(), "Something went wrong"}});
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

kill_worker(Pid) ->
  io:format("Killing worker ~p~n", [Pid]),
  exit(Pid, kill).

loop(Parent, Dict) ->
  receive 
    exit -> 
      Keys = dict:fetch_keys(Dict),
      [kill_worker(Pid) || Pid <- Keys],
      unregister(?MODULE),
      exit(kill);

    see_workers ->
      Pids = dict:fetch_keys(Dict),
      io:format("Workers: ~p~n", [Pids]),
      loop(Parent, Dict);

    inspect_workers ->
      Pids = dict:fetch_keys(Dict),
      io:format("Workers: ~p~n", [Pids]),
      [io:format("~p~n~n", [process_info(Pid)]) || Pid <- Pids],
      loop(Parent, Dict);

    {do_calc, N} when is_number(N) ->
      WorkerPid = spawn(?MODULE, calc_work, [self(), N]),
      NewDict = dict:store(WorkerPid, WorkerPid, Dict),
      loop(Parent, NewDict);

    {WorkerPid, {result, Result}} ->
      io:format("The process ~p executed with the result ~p~n", [WorkerPid, Result]),
      NewDict = dict:erase(WorkerPid, Dict),
      loop(Parent, NewDict);

    {error, {WorkerPid, Message}} ->
      io:format("Erro: ~p [~p]~n", [Message, WorkerPid]),
      NewDict = dict:erase(WorkerPid, Dict),
      loop(Parent, NewDict);

    Any ->
      io:format("Unexpected Result: ~p~n", [Any]),
      loop(Parent, Dict)
  end.

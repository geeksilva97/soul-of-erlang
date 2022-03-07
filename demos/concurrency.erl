-module(concurrency).
-export([run/0, serve/0, math/0]).
% -compile([export_all]).

serve() ->
  receive
    Request -> 
      io:format("Handling: ~s~n", [Request]),
      serve()
  end.

math() ->
  receive
    {add, X, Y} ->
      io:format("~p + ~p = ~p~n", [X, Y, X+Y]),
      math();
    {sub, X, Y} ->
      io:format("~p - ~p = ~p~n", [X, Y, X-Y]),
      math();
    Any ->
      io:format("I can't handle the operation ~p~n", [Any]),
      math()
  end.

run() ->
  io:format("Starting execution in the main process with PID: ~p~n", [self()]),
  Pid = spawn(?MODULE, serve, []),
  Pid ! request1,
  Pid ! request2,
  timer:sleep(1000),

  Pid2 = spawn(?MODULE, math, []),
  Pid2 ! {add, 10, 2},
  Pid2 ! {sub, 11, 5},
  Pid2 ! {mul, 2, 4},
  io:format("Finishing execution in the main process with PID: ~p~n", [self()]).

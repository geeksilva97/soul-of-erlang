-module(silly_module).
-export([run/0, loop/1]).

run() ->
  spawn(?MODULE, loop, ["Hello world"]).

loop(Message) -> do_loop(1, Message).

do_loop(N, Message) ->
  io:format("Loop ~p // Message: ~p~n", [N, Message]),
  timer:sleep(1200),
  do_loop(N+1, Message).

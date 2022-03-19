-module(silly_module).
-export([start/0, loop/1]).

start() ->
  spawn(?MODULE, loop, [1]).

loop(N) ->
  receive
    stop ->
      io:format("FINISH HIM...~n"),
      ok
  after 2000 ->
          % io:format("Loop ~p | Hello Erlang!~n", [N]),
          io:format("Loop ~p | Let's put a smile on that face :)~n", [N]),
          ?MODULE:loop(N+1)
  end.


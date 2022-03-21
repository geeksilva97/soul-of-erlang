-module(ch_app).
-behaviour(application).

-export([start/2, stop/1]).

start(Type, _Args) ->
  io:format("Starting application with type ~p~n", [Type]),
  % starts the supervisor tree
  ch_sup:start_link().

stop(_State) ->
  ok.

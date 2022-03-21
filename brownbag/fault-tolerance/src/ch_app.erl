-module(ch_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
  % starts the supervisor tree
  ch_sup:start_link().

stop(_State) ->
  ok.

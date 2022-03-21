-module(ch_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(ch_sup, []).

init(_Args) ->
    RestartStrategy = one_for_one,
    MaxR = 1, % max restarts
    MaxT = 60, % max time 
    ChildSpec1 =            {ch3, {ch3, start_link, []},
            permanent, brutal_kill, worker, [ch3]},
    ChildSpec2 =            {ch4, {ch4, start_link, []},
            permanent, brutal_kill, worker, [ch4]},
    {ok, {{RestartStrategy, MaxR, MaxT},
          [ChildSpec1, ChildSpec2]}}.

-module(ch4).
-behaviour(gen_server).

% Functions needed for gen_server
-export([init/1, handle_call/3, handle_cast/2]).
-export([set_state/1, get_state/0, stop/0, terminate/2, start_link/0]).

start_link() ->
  gen_server:start_link({local,ch4}, ch4, [], []).

init(_Args) ->
  {ok, 0}.

set_state(NewState) ->
  gen_server:call(ch4,{new_state, NewState}).

get_state() ->
  gen_server:call(ch4, get).

stop() ->
  gen_server:cast(ch4, stop).

handle_cast({new_state, NewState}, _State) ->
  {stop, normal, NewState};
handle_cast(stop, State) ->
  {stop, normal, State}.

handle_call(get, _From, State) ->
  {reply, State, State}.

terminate(normal, _State) -> ok;
terminate(shutdown, _State) -> ok.

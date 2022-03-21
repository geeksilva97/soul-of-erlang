-module(ch3).
-behaviour(gen_server).

% Functions needed for gen_server
-export([init/1, handle_call/3, handle_cast/2]).
-export([decrement/0, increment/0, get_state/0, stop/0, terminate/2, start_link/0]).

start_link() ->
  gen_server:start_link({local,ch3}, ch3, [], []).

init(_Args) ->
  {ok, 0}.

increment() ->
  gen_server:cast(ch3, increment).

decrement() ->
  gen_server:cast(ch3, decrement).

get_state() ->
  gen_server:call(ch3, get).

stop() ->
  gen_server:cast(ch3, stop).

handle_cast(stop, State) ->
  {stop, normal, State};
handle_cast(increment, State) ->
  {noreply, State + 1};
handle_cast(decrement, State) ->
  {noreply, State - 1}.

handle_call(get, _From, State) ->
  {reply, State, State}.

terminate(normal, _State) -> ok;
terminate(shutdown, _State) -> ok.

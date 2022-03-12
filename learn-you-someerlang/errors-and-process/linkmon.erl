-module(linkmon).
-export([chain/1,
         start_critic/0,
         judge/3,
         judge2/2,
         critic/0,
         critic2/0,
         restarter/0,
         start_critic2/0
]).

start_critic2() ->
  spawn(?MODULE, restarter, []).

restarter() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(?MODULE, critic2, []),
  register(critic, Pid),
  receive
    {'EXIT', Pid, normal} -> ok;
    {'EXIT', Pid, shutdown} -> ok;
    {'EXIT', Pid, _Reason} -> restarter()
  end.

judge2(Band, Album) ->
  Ref = make_ref(),
  critic ! {self(), Ref, {Band, Album}},
  io:format("Sent from ~p to ~p~n", [self(), whereis(critic)]),
  receive
    {Ref, Criticism} -> Criticism
  after 2000 -> timeout
  end.

critic2() ->
  receive
    {From, Ref, {"Rage Against the Turing Machine", "Unit Testify"}} ->
      From ! {Ref, "They are great!"};
    {From, Ref, {"System of a Downtime", "Memoize"}} ->
      From ! {Ref, "They're not Johnny Crash but they're good."};
    {From, Ref, {"Johnny Crash", "The Token Ring of Fire"}} ->
      From ! {Ref, "Simply incredible."};
    {From, Ref, {_Band, _Album}} ->
      From ! {Ref, "They are terrible!"}
  end,
  critic2().

start_critic() ->
  spawn(?MODULE, critic, []).

judge(Pid, Band, Album) ->
  Pid ! {self(), {Band, Album}},
  receive
    {Pid, Criticism} -> Criticism
  after 2000 ->
          timeout
  end.

critic() ->
  receive
    {From, {"Rage Against the Turing Machine", "Unit Testify"}} ->
      From ! {self(), "They are great!"};
    {From, {"System of a Downtime", "Memoize"}} ->
      From ! {self(), "They're not Johnny Crash but they're good."};
    {From, {"Johnny Crash", "The Token Ring of Fire"}} ->
      From ! {self(), "Simply incredible."};
    {From, {_Band, _Album}} ->
      From ! {self(), "They are terrible!"}
  end,
  critic().

chain(0) ->
  receive
    _ -> ok
  after 2000 ->
    exit("chain dies here")
  end;
chain(N) ->
  Pid = spawn(fun() -> chain(N-1) end),
  link(Pid),
  receive
    _ -> ok
  end.

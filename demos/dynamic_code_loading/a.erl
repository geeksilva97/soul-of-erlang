-module(a).
-compile([export_all]).

start(Tag) ->
  spawn(fun() -> loop(Tag) end).

loop(Tag) ->
  timer:sleep(3000),
  Val = b:x(),
  io:format("Vsn1 (~p) b:x() = ~p~n", [Tag, Val]),
  loop(Tag).

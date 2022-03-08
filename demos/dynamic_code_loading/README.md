# How to test

### Start

```
c(a).
{ok, b}
c(b).
{ok, a}
a:start(one)
<9.99.9> # your PID
a:start(two)
<9.99.9> # your PID
```

### Update module b

```erl
-module(b).
-export([x/0]).

x() -> 2.
```

Recompile `b` in `erl`

```
c(b).
{ok, b}
```

## Update module a

```erl
-module(a).
-compile([export_all]).

start(Tag) ->
  spawn(fun() -> loop(Tag) end).

loop(Tag) ->
  timer:sleep(3000),
  Val = b:x(),
  io:format("Vsn1 (~p) b:x() = ~p~n", [Tag, Val]),
  loop(Tag).
```


Recompile `a` in `erl`

```
c(a).
{ok, a}
a:start(three).
```

### Change b module again
Change the return of function `x` recompile b.

### Change a module again
Change from `Vsn2` to `Vsn3` in `loop` function, recompile `a` and run `a:start(four)`.

## Results
When we recompile b our code get the changes. When we recompile a our old code keeps running, but when we change again it drops the ancient execution. Erlang keeps executing two versions of a module.

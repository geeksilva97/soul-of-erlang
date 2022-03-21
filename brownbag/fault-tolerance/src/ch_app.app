{application, ch_app,
 [{description, "Brownbag demo"},
  {vsn, "1"},
  {modules, [ch_app, ch_sup, ch3, ch4]},
  {registered, [ch3, ch4]},
  {applications, [kernel, stdlib]},
  {mod, {ch_app,[]}}
 ]}.

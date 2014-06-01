-module(feeds_app).
-behaviour(application).
-export([start/2, stop/1]).

%% Public interface
start(_Type, [Port]) ->
    io:format("Starting feeds app...~p~n", [Port]),
    {ok, LSocket} = gen_tcp:listen(Port, [{active, true}]),
    main_sup:start_link(LSocket).

stop(_State) ->
    io:format("Stopping feeds app...~n"),
    ok.

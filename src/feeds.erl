-module(feeds).
-behaviour(application).
-export([start/2, stop/1]).

%% Public interface
start(_Type, [Port]) ->
    io:format("Starting feeds server...~p~n", [Port]),
    {ok, LSocket} = gen_tcp:listen(Port, [{active, true}]),
    feeds_sup:start_link(LSocket),
    feeds_sup:start_child().

stop(_State) ->
    io:format("Stopping feeds server...~n"),
    ok.

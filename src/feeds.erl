-module(feeds).
-behaviour(application).
-export([start/2, stop/1]).

%% Public interface
start(_Type, _StartArgs) ->
    io:format("Starting feeds server...~n"),
    feeds_sup:start_link().

stop(_State) ->
    io:format("Stopping feeds server...~n"),
    ok.

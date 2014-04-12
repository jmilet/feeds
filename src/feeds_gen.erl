-module(feeds_gen).
-behaviuour(gen_server).
-export([start_link/0, init/1]).

%% Public interface
start_link() ->
    io:format("Starting feeds_gen...~n", []),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% Callbacks
init(_Args) ->
    io:format("Initating feeds_gen...~n", []),
    {ok, {}}.

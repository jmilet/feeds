-module(login_gen).
-behaviuour(gen_server).
-export([start_link/0, init/1, handle_cast/2, handle_info/2, terminate/2]).

-record(state, {}).

%% Public interface
start_link() ->
    io:format("Starting login_gen...~n", []),
    gen_server:start_link(?MODULE, [], []).

%% Callbacks
init([]) ->
    io:format("Initating login_gen...~n"),
    State = #state{},
    {ok, State, 0}.

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_info(timeout, State) ->
    {noreply, State}.

terminate(_Reaseon, _State) ->
    ok.


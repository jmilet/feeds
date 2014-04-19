-module(feeds_gen).
-behaviuour(gen_server).
-export([start_link/1, init/1, handle_info/2]).

-record(state, {lsocket}).

%% Public interface
start_link(LSocket) ->
    io:format("Starting feeds_gen...~n", []),
    gen_server:start_link(?MODULE, [LSocket], []).

%% Callbacks
init([LSocket]) ->
    io:format("Initating feeds_gen...~p~n", [LSocket]),
    State = #state{lsocket = LSocket},
    {ok, State, 0}.

handle_info({tcp, Socket, RawData}, State) ->
    io:format("Text: ~p~n", [RawData]),
    gen_tcp:send(Socket, RawData),
    {noreply, State};
handle_info(timeout, State) ->
    LSocket = State#state.lsocket,
    io:format("Accepting socket~p~n", [LSocket]),
    {ok, ASocket} = gen_tcp:accept(LSocket),
    io:format("After acceptint socket, asking for a new child process~n"),
    feeds_sup:start_child(),
    {noreply, State}.


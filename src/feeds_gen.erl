-module(feeds_gen).
-behaviuour(gen_server).
-export([start_link/1, init/1, handle_info/2, terminate/2, handle_cast/2]).

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

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_info({tcp, Socket, RawData}, State) ->
    %%io:format("Text: ~p~n", [RawData]),
    case string:tokens(RawData, "/") of
	["login", Usuario] ->
	    Resultado = login(Usuario);
	_ ->
	    Resultado = "Error"
    end,
    gen_tcp:send(Socket, Resultado ++ "\n"),
    %%gen_tcp:close(Socket),
    case RawData =:= "crash\r\n" of
	true ->
	    A = 1 /0;
	false -> false
    end,
    {noreply, State};
handle_info({tcp_closed, _Socket}, State) ->
    {stop, normal, State};
handle_info({tcp_error, _Socket}, State) ->
    {stop, normal, State};
handle_info(timeout, State) ->
    LSocket = State#state.lsocket,
    io:format("Accepting socket~p~n", [LSocket]),
    {ok, ASocket} = gen_tcp:accept(LSocket),
    io:format("After acceptint socket, asking for a new child process~n"),
    tcp_sup:start_child(),
    {noreply, State}.

terminate(_Reaseon, _State) ->
    ok.

login(Usuario) ->
    "ok".

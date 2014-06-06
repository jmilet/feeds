-module(tcp_gen).
-behaviuour(gen_server).
-export([start_link/1, init/1, handle_info/2, terminate/2, handle_cast/2]).
-include("include/login_gen.hrl").

-record(state, {lsocket, user = nil}).

%% Public interface
start_link(LSocket) ->
    io:format("Starting tcp_gen...~n", []),
    gen_server:start_link(?MODULE, [LSocket], []).

%% Callbacks
init([LSocket]) ->
    io:format("Initating tcp_gen...~p~n", [LSocket]),
    State = #state{lsocket = LSocket},
    {ok, State, 0}.

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_info({tcp, Socket, RawData}, State) ->
    case cleaned(string:tokens(RawData, "|")) of
	["login", UserId, Password] ->
	    case State#state.user of
		nil ->
		    {ok, User} = login_gen:login(UserId, Password),
		    User2 = User#user{login = true},
		    gen_tcp:send(Socket, "ok\n"),
		    {noreply, State#state{user = User2}};
		_ ->
		    gen_tcp:send(Socket, "error. Already login\n"),
		    {noreply, State}
	    end;

	["register", Url] ->
	    case State#state.user of
		nil ->
		    gen_tcp:send(Socket, "error. Not login\n"),
		    {noreply, State};
		_ ->
		    User = State#state.user,
		    AllUrls = [Url | lists:delete(Url, User#user.urls)],
		    gen_tcp:send(Socket, "ok\n"),
		    {noreply, State#state{ user = User#user{urls = AllUrls} }}
	    end;

	["list"] ->
	    case State#state.user of
		nil ->
		    gen_tcp:send(Socket, "error. Not login\n"),
		    {noreply, State};
		_ ->
		    User = State#state.user,
		    lists:foreach(fun(F) ->
					  gen_tcp:send(Socket, io_lib:format("~p~n", [F])) end,
				  User#user.urls),
		    gen_tcp:send(Socket, "ok\n"),
		    {noreply, State}
	    end;
	
	["quit"] ->
	    case State#state.user of
		nil ->
		    gen_tcp:send(Socket, "error. Not login\n"),
		    {noreply, State};
		_ ->
		    gen_tcp:send(Socket, "ok\n"),
		    gen_tcp:close(Socket),
		    {stop, normal, state}
	    end;

	_ ->
	    gen_tcp:send(Socket, "Error\n"),
	    {noreply, State}
    end;
handle_info({tcp_closed, _Socket}, State) ->
    {stop, normal, State};
handle_info({tcp_error, _Socket}, State) ->
    {stop, normal, State};
handle_info(timeout, State) ->
    LSocket = State#state.lsocket,
    io:format("Accepting socket~p~n", [LSocket]),
    {ok, _ASocket} = gen_tcp:accept(LSocket),
    io:format("After acceptint socket, asking for a new child process~n"),
    tcp_sup:start_child(),
    {noreply, State}.

terminate(_Reaseon, _State) ->
    ok.

cleaned(Tokens) ->
    lists:map(fun(T) -> re:replace(T, "\r\n", "", [{return, list}]) end, Tokens).
		      

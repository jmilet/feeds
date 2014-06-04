-module(login_gen).
-behaviuour(gen_server).
-export([start_link/0, init/1, handle_cast/2, handle_call/3, handle_info/2, terminate/2, login/2]).
-include("include/login_gen.hrl").

-record(state, {users}).

-define(SERVER, ?MODULE).

%% Public interface
start_link() ->
    io:format("Starting login_gen...~n", []),
    UsersDB = dict:new(),
    UsersDB2 = dict:store("guest", #user{id = "guest", password = "guest"}, UsersDB),
    gen_server:start_link({local, ?SERVER}, ?MODULE, #state{users = UsersDB2}, []).

login(UserId, Password) ->
    io:format("--------------"),
    gen_server:call(?SERVER, {login, UserId, Password}).

%% Callbacks
init(State) ->
    io:format("Initating login_gen...~n"),
    io:format("With state: ~p~n", [State]),
    {ok, State, 0}.

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_info(timeout, State) ->
    {noreply, State}.

handle_call({login, UserId, Password}, From, State) ->
    case dict:find(UserId, State#state.users) of
	{ok, User} ->
	    io:format("~p~p~n", [User, Password]),
	    if User#user.password == Password ->
		    {reply, {ok, User#user{login = true}}, State};
	       true ->
		    {reply, error1, State}
	    end;
	_ ->
	    {reply, error2, State}
    end.
     
terminate(_Reaseon, _State) ->
    ok.


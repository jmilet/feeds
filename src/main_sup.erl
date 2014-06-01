-module(main_sup).
-behaviour(supervisor).
-export([start_link/1, init/1]).

-define(SERVER, ?MODULE).

%% Public interface
start_link(LSocket) ->
    io:format("Starting main_sup...~n"),
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSocket]).

%% Callbacks
init([LSocket]) ->
    {ok, {restart_strategy(), worker_spec(LSocket)}}.

%% Private
restart_strategy() ->
    {one_for_one, 3, 60}.

worker_spec(LSocket) ->
    [{tcp_sup,
      {tcp_sup, start_link, [LSocket]},
      temporary,
      1000,
      supervisor,
      [tcp_sup]}].


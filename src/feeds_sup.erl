-module(feeds_sup).
-behaviour(supervisor).
-export([start_link/1, init/1, start_child/0]).

-define(SERVER, ?MODULE).

%% Public interface
start_link(LSocket) ->
    io:format("Starting feeds_sup...~n", []),
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSocket]).

start_child() ->
    io:format("In start_child~n"),
    supervisor:start_child(?SERVER, []).

%% Callbacks
init([LSocket]) ->
    io:format("Initating feeds_sup...~n", []),
    {ok, {restart_strategy(), worker_spec(LSocket)}}.

%% Private
restart_strategy() ->
    %% How the workers should be restarted.
    {simple_one_for_one, 3, 60}.


worker_spec(LSocket) ->
    %% How workers should be managed.

    [{feeds_gen,                     %% A name for our worker spec.
      {feeds_gen, start_link, [LSocket]},   %% The module, function and params of our workers.
                                     %% Worker's execution entry point.
      temporary,                     %% How the worker should be restarted.
                                     %% transient means restart only if it abnormally
                                     %% terminated.
      1000,                          %% Milliseconds to wait for worker's shutdown.
                                     %% After that time the supervisor will abruptly
                                     %% terminate it.
      worker,                        %% Defines a subordinate process type, a worker
                                     %% in this case, but it could has been another
                                     %% supervisor.
      [feeds_gen]}].                 %% One element list with the worker's module.



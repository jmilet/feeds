-module(feeds_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

%% Public interface
start_link() ->
    io:format("Starting feeds_sup...~n", []),
    supervisor:start_link(?MODULE, []).

%% Callbacks
init(_Args) ->
    io:format("Initating feeds_sup...~n", []),
    {ok, {restart_strategy(), workers()}}.

%% Private
restart_strategy() ->
    %% How the workers should be restarted.
    {one_for_one, 1, 60}.

workers() ->
    %% List of supervised workers.
    [worker_spec()].

worker_spec() ->
    %% How workers should be managed.

    {chfeeds,                       %% A name for our worker spec.
     {feeds_gen, start_link, []},   %% The module, function and params of our workers.
                                    %% Worker's execution entry point.
     transient,                     %% How the worker should be restarted.
                                    %% transient means restart only if it abnormally
                                    %% terminated.
     3000,                          %% Milliseconds to wait for worker's shutdown.
                                    %% After that time the supervisor will abruptly
                                    %% terminate it.
     worker,                        %% Defines a subordinate process type, a worker
                                    %% in this case, but it could has been another
                                    %% supervisor.
     [feeds_sup]}.                  %% One element list with the worker's module.

	    

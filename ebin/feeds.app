{application, feeds,
   [{description, "Minimal feeds service"},   %% Literal description of our app
    {vsn, "0.1.0"},                           %% Version
    {modules, [feeds]},                       %% Modules our app is composed of
    {resitered, []},                          %% Registerd processes. This is necessary
                                              %% in order to let the system detect
                                              %% registered names clashes
    {applications, [kernel, stdlib]},         %% Applications our app depends on
    {mod, {feeds, []}}                        %% Our main's application module and
                                              %% an empty list of parameters
                                              %% (in this case)
]}.

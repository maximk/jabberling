-module(jabberling_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).
-export([start/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
	application:start(sasl),

	application:start(mnesia),
	application:set_env(mnesia, dir, "/jabberling/db"),

	application:start(crypto),
	application:start(public_key),
	application:start(ssl),
	application:start(stringprep),

	application:start(ejabberd),

	application:start(jabberling).

start(_StartType, _StartArgs) ->
    jabberling_sup:start_link().

stop(_State) ->
    ok.

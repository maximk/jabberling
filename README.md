
# Making ejabberd run on LING VM

The log of changes follows:

* rebar

A standard source of ejabberd from P1 (https://github.com/processone/ejabberd)
does not work with rebar. There are a couple of "rebarized" versions. I took the
one by treacheroustalks (https://github.com/treacheroustalks/ejabberd-app).
There is also a required companion application, stringprep
(https://github.com/treacheroustalks/stringprep-app). Both added as rebar
dependencies.

* c\_src

c\_src directories of both ejabberd and stringprep are moved to \_\_REMOVED
directory. rebar builds everything cleanly.

* standard deps

The following application dependencies found: sasl, crypto, public\_key, ssl,
mnesia. All this applications are imported to the image and start successfully.

* stringprep

Yet another dependency is stringprep. The purpose of the application is not
clear. It is rewritten not to use driver and spew arguments of all calls.

* ejabberd\_loglevel

application:start(ejabberd) fails because ejabberd\_loglevel.erl uses a dynamic
compilation (for efficiency?). Upon initialization ejabberd\_loglevel:set(4) is
called. The ejabberd\_logger.erl module that corresponds to this level is
generated and added to the source tree. The module is also added to
ejabberd.app.

* db\_init

ejabberd\_app:db\_init restarts mnesias. Calling application:stop(mnesia) leads
to the complete shutdown. Stuck.


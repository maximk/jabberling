
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

ejabberd\_app:db\_init restarts mnesia. Calling application:stop(mnesia) leads
to a complete shutdown. The shutdown was due to a bug in process\_info(\_,
group\_leader). mnesia restarts cleanly now.

* sha

Module sha loads a driver. sha.erl heavily edited to use standard crypto:\*
routines and not load the driver.

* xml

A possibility to use --enable-nif removed in xml.erl. File xml.c removed.

* drivers

The start sequence starts tls\_drv and expat\_erl drivers. The line is
commented out. Another line that loads ASN1.0 driver commented out too because
it produces a deprecated message (and is noop).

* mnesia

Mnesia creates a subdirectory in the project directory. The project directory is
not writable. A writable directory is mounted over 9p and designated as a
database directory to Mnesia.

* missing

ejabberd uses system\monitor() functions. Functions are stubbed and do nothing.
When opening a listening socket it sets the send timeout. The TCP driver updated
to support the option fully. mod\_caps wants to know the number of logical
processors. system\_info(logical\_processors) always returns 1.


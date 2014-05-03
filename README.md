Wsystem hat is this station?
=====================

The Station Incognito is a tool for the establishment of a cloak of anonymity
in an otherwise ordinary environment. To wit, a station from which all traffic
on the network is routed through Tor, or does not proceed at all.

How does one use it?
====================

The Station Incognito runs within your desktop as any other program. This task
demands the prerequisite installation of Vagrant to enclose a desktop within a
desktop. You may do well to use a virtual Ruby environment as well, such as RVM
or rbenv.

Once you have done this, these incantations at the base of the repository will
raise The Station Incognito...

```
# bundle install
# bundle exec rake clean build
# vagrant up
```

The process requires - with goodly bandwidth - the greater part of an hour.
This is mostly accounted for in the vast quantity of software needed to form
the station.

Caveats and Limitations
=======================

There are always limits. The Station Incognito cannot prevent you from
revealing yourself in spite of your cloak. Many destinations are only useful
once you have identified yourself. Alas, some software will fail. The Station
Incognito cannot conceal UDP-based communications, and so they are blocked
entirely, affecting many voice applications. Finally, The Station Incognito
cannot accept connections from without, hindering server and peer-to-peer
tools.

How it works
============

The Station's security is based on four main elements. First, a shorewall-based
firewall stops all non-local traffic except that which it can redirect to a
SOCKS proxy. Second, redsocks intercepts the redirected traffic and sends it
through a Tor SOCKS proxy. Third, Tor connects to the Tor network through a
pre-configured bridge node. Fourth, unbound handles DNS queries locally and
resolves them over TCP, so that the queries can be proxied.

Configuration
=============

In the root of the repository, in a file called *Vagrantfile*, there are three
items which you may configure. These are the IP, ORPort, and fingerprint of
your Tor bridge relay. The default values are the IP, ORPort, and fingerprint
of the well-known and Chaos Computer Club nodes in Germany. You may choose any
node whose ORPort you can access, including a node on a local network.

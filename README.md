playnit
=======

Social gaming checkins. And stuff.

Contact us at: i.am@playn.it

Requires
--------

 * Ruby 1.9.3
 * Rails 3
 * Postgres
 * Redis

Installation
------------

 $ git clone git@github.com:ollej/playnit.git
 $ cd playnit
 $ bundle install
 $ git remote add dokku dokku@example.com:playnit
 $ export DEVISE_SECRET_KEY="`rake secret`"
 $ export SECRET_TOKEN="`rake secret`"
 $ git push dokku master

playnit
=======

Social gaming checkins.

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
 $ ssh -t example.com dokku config:set DEVISE_SECRET_KEY="`rake secret`"
 $ ssh -t example.com dokku config:set SECRET_TOKEN="`rake secret`"
 $ git push dokku master

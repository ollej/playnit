playnit
=======

Social gaming checkins.

Contact us at: i.am@playn.it

Requires
--------

 * Ruby 2.0.0
 * Rails 4.0
 * Postgres
 * Redis

Installation
------------

```bash
 $ git clone git@github.com:ollej/playnit.git
 $ cd playnit
 $ bundle install
 $ rails s
```

### Install on dokku

 * Install dokku as per its instructions.
 * Install redis plugin
 * Install postgresql plugin

```bash
 $ git remote add dokku dokku@example.com:playnit
 $ git push dokku master
 $ ssh -t example.com dokku config:set DEVISE_SECRET_KEY="`rake secret`"
 $ ssh -t example.com dokku config:set SECRET_TOKEN="`rake secret`"
 $ ssh -t example.com dokku redis:create playnit
 $ ssh -t example.com dokku postgresql:create playnit
 $ ssh -t example.com dokku postgresql:link playnit playnit
 $ ssh -t example.com dokku redis:link playnit playnit
 $ ssh -t example.com dokku run playnit rake db:migrate
```



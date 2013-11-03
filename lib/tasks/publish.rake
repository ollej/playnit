#!/usr/bin/env rake

require 'fileutils'

app = 'calm-plains-7356'

namespace :publish do
  desc "Compile application"
  task :compile do
    system("bundle exec rake assets:precompile RAILS_ENV=production") or fail
  end

  desc "Push to heroku"
  task :push do
    sh %{git push heroku master}
  end

  desc "Migrate db on heroku"
  task :migrate do
    system("heroku run rake db:migrate --app #{app}") or fail
  end

  desc "Restart heroku app"
  task :restart do
    sh %{heroku restart --app #{app}}
  end

  task :tag do
    release_name = "REL-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    puts "Tagging release as '#{release_name}'"
    sh %{git tag -a #{release_name} -m 'Tagged release'}
    sh %{git push --tags}
  end

  desc "Release app to heroku"
  task :release => ['publish:push', 'publish:migrate', 'publish:restart', 'publish:tag']
end


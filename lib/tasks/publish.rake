#!/usr/bin/env rake

require 'fileutils'

# Returns true if all files are committed to git repo.
def git_clean
  status = %x{git status 2> /dev/null}
  return status =~ /working directory clean/
end

namespace :publish do
  desc "Compile application"
  task :compile do
    fail "Please commit all changes before release." if !git_clean()
    #sh %{RAILS_ENV=production bundle exec rake assets:precompile}
    system("bundle exec rake assets:precompile RAILS_ENV=production")
    #ActiveRecord::Base.establish_connection('production')
    #Rake::Task["assets:precompile"].invoke
    #ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'])
  end

  desc "Commit assets to repo"
  task :commitassets => :compile do
    sh %{git add public/assets}
    sh %{git commit -m "Commit compiled assets."}
  end

  desc "Push to heroku"
  task :push do
    sh %{git push heroku master}
  end

  desc "Migrate db on heroku"
  task :migrate do
    sh %{heroku run rake db:migrate}
  end

  desc "Restart heroku app"
  task :restart do
    sh %{heroku restart}
  end

  task :tag do
    release_name = "REL-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    puts "Tagging release as '#{release_name}'"
    sh %{git tag -a #{release_name} -m 'Tagged release'}
    sh %{git push --tags}
  end

  desc "Release app to heroku"
  task :release => ['publish:commitassets', 'publish:push', 'publish:migrate', 'publish:restart', 'publish:tag']
end


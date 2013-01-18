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
    ActiveRecord::Base.establish_connection('production')
    Rake::Task["assets:precompile"].invoke
    ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'])
  end

  desc "Commit assets to repo"
  task :commitassets => :compile do
    sh %{echo git add public/assets}
    sh %{echo git commit -m "Commit compiled assets."}
  end

  desc "Release app to heroku"
  task :release => :commitassets do
    sh %{echo git push heroku master}
  end
end


#!/bin/bash

function compile {
    # Precompile assets
    echo "Compiling..."
    RAILS_ENV=production bundle exec rake assets:precompile
}

function commit {
    # Commit compiled assets
    echo "Commiting..."
    git add public/assets
    git commit -m "Commit compiled assets."
}

function release {
    # Push to heroku
    echo "Pushing to heroku..."
    git push heroku master
}

function heroku_release {
    compile
    commit
    release
}

# Check if everything is committed
git_status="$(git status 2> /dev/null)"
if [[ ${git_status} =~ "working directory clean" ]]; then
    heroku_release
else
    echo "Please commit all changes before release."
fi


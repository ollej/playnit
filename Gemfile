source 'http://rubygems.org'

ruby '2.3.5'
gem 'rails', '4.1.16'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'radix62', git: 'https://github.com/ollej/radix62'

gem 'pg'
gem 'authlogic', '~> 3.4.5'
gem 'devise', '~> 3.4.1'
gem 'eco', '~> 1.0.0'
gem 'newrelic_rpm', '~> 3.11.1.284'
gem 'twitter-bootstrap-rails', '~> 2.2.8'
gem 'therubyracer', '~> 0.12.1', platforms: :ruby
gem 'redis-rails'
gem 'bgg-api', '~> 0.0.2'
gem 'fog', '~> 1.37.0'
gem 'unf', '~> 0.1.4'
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick', '~> 4.3.6'
gem 'omniauth-google-oauth2', '~> 0.3.1'

gem 'sass-rails', '~> 5.0.4'#,   '~> 4.0.1'
gem 'compass-rails', '~> 2.0.4'
gem 'coffee-rails', '~> 4.0.1'
#gem 'uglifier'#, '>= 1.0.3'

gem 'jquery-rails', '~> 3.1.2'
gem 'jquery-ui-rails', '~> 5.0.3'
#gem 'zepto-rails', :github => 'frontfoot/zepto-rails'
gem 'underscore-rails', '~> 1.8.2'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn-rails', '~> 2.2.0'

# Deploy with Capistrano
# gem 'capistrano'

group(:development) do
  # To use debugger
  #gem 'debugger'
  gem 'shotgun'
  gem 'spring'
end

group(:test) do
  gem 'sqlite3'
end

group(:production) do
  gem 'rails_12factor', '~> 0.0.3'
end

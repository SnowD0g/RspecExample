source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.3.4'
gem 'rails', '~> 5.2.0'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'haml-rails'
gem 'simple_form', '~> 4.0', '>= 4.0.1'
gem 'devise'
gem 'twitter'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', '~> 1.7'
  gem 'jasmine-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara' #driver di default è chrome headless
  gem 'rails-controller-testing' # deprecato
  gem 'email_spec'
  gem 'vcr'
  gem 'webmock'
  gem 'poltergeist'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

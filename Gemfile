# encoding: utf-8
# frozen_string_literal: true

source 'https://rubygems.org'

group :development do
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-kitchen'
  gem 'guard-rspec'
  gem 'yard-chef'
end

group :test do
  gem 'chefspec'
  gem 'coveralls'
  gem 'fauxhai'
  gem 'foodcritic'
  gem 'kitchen-docker'
  gem 'kitchen-dokken'
  gem 'kitchen-vagrant'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'test-kitchen'
end

group :integration do
  gem 'serverspec'
end

group :deploy do
  gem 'stove'
end

group :production do
  gem 'berkshelf',
      ('< 6' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.3.3'))
  gem 'chef', '>= 12.5'
end

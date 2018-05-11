# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'
require 'simplecov'
require 'simplecov-console'

RSpec.configure do |c|
  c.add_setting :supported_platforms, default: {
    centos: %w[7.4.1708 6.9],
    debian: %w[9.3 8.10],
    redhat: %w[7.4 6.9],
    # TODO: A Fauxhai with the Ubuntu 18.04 definition has yet to be released
    #       with a stable Chef-DK.
    ubuntu: %w[16.04 14.04]
  }
end

SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.minimum_coverage(100)
SimpleCov.start

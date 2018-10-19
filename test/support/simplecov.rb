# frozen_string_literal: true

if ENV['PARALLEL_TEST_GROUPS']
  require 'simplecov'
  require 'simplecov-console'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
  SimpleCov.command_name ENV['PARALLEL_TEST_GROUPS'] + (ENV['TEST_ENV_NUMBER'] || '')
  SimpleCov.merge_timeout 3600
  SimpleCov.start('rails')
end

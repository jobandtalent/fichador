# frozen_string_literal: true

require 'support/simplecov'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'support/application_system_test_case'
ApplicationSystemTestCase.config

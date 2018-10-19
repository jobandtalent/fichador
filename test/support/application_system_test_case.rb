# frozen_string_literal: true

require 'test_helper'
require 'socket'
require 'support/webpack_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include WebpackHelper
  class << self; attr_accessor :host end

  def self.resolve_host_address
    IPSocket.getaddress(Socket.gethostname)
  rescue StandardError
    puts 'Cannot identify host address for Capybara, using 127.0.0.1'
    '127.0.0.1'
  end

  def self.config
    Capybara.app = Rack::Builder.new_from_string File.read(Rails.root.join('config.ru'))

    @host = ENV.fetch('CAPYBARA_HOST') { ApplicationSystemTestCase.resolve_host_address }
  end

  def self.driver_options(options = {})
    ENV['SELENIUM_SERVER_URL'].tap { |value| options[:url] = value unless value.nil? }
    options
  end

  puts "Using selenium: #{driver_options.inspect}"
  driven_by :selenium,
            using: :chrome,
            screen_size: [1280, 800],
            options: driver_options

  def setup
    check_assets_manifest!
    Capybara.server_host = ApplicationSystemTestCase.host
    host! "http://#{Capybara.server_host}"
    super
  end
end

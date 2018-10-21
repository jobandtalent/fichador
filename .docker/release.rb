# frozen_string_literal: true

require_relative './build_helper'
using Rainbow

puts 'Stop running containers'.cyan
cmd 'docker-compose', 'stop', stop_on_error: true
puts "\n"

puts 'Removing pregenerated assets (packs)'.cyan
cmd 'rm -rf', '../public/packs*', stop_on_error: true
puts "\n"

puts 'Build webpack images'.cyan
cmd 'docker-compose build', 'fichador-webpack', stop_on_error: true
puts "\n"

puts 'Build JS assets'.cyan
cmd 'docker-compose run --rm --no-deps', 'fichador-webpack build', stop_on_error: true
puts "\n"

puts 'Build Rails Image'.cyan
cmd 'docker-compose build', 'fichador-app', stop_on_error: true
puts "\n"

exit(0)

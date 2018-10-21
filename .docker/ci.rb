# frozen_string_literal: true

require_relative './build_helper'
using Rainbow

puts 'Stop running containers'.cyan
cmd 'docker-compose', 'stop', stop_on_error: true
puts "\n"

puts 'Removing pregenerated assets (packs)'.cyan
cmd 'rm -rf', '../public/packs*', stop_on_error: true
puts "\n"

puts 'Launch required services (postgres & selenium)'.cyan
cmd 'docker-compose', 'up -d selenium-server fichador-postgres', stop_on_error: true
puts "\n"

puts 'Build containers'.cyan
cmd 'docker-compose', 'build', stop_on_error: true
puts "\n"

puts 'Prepare & Run Tests'
steps = [
  ['fichador-app', 'rails db:create db:migrate', 'DB setup'],
  ['fichador-webpack-installer', '', 'JS dependencies'],
  ['fichador-webpack', 'build', 'JS Transpiling'],
  ['fichador-app', 'rails test "test/**/*_test.rb"', 'Rails App Tests'],
  ['fichador-app', 'rubocop', 'Rails Code Formatting'],
  ['fichador-app', 'script/check-vulnerabilities', 'Ruby vulnerabilities Analysis'],
  ['fichador-app', '"apk add --no-cache git && script/check-dependencies"', 'Static Code Analysis'],
  ['fichador-webpack', 'test', 'JS tests'],
  ['fichador-webpack', 'eslint', 'JS Code Formatting']
]

results = steps.map do |container, command, step_name|
  puts "\n #{step_name}".cyan
  result = cmd('docker-compose run --rm --no-deps -e CI=1', "#{container} #{command}")
  [step_name, result]
end

puts "\n\nCI results:".cyan

results.each { |step, ok| puts "#{ok ? 'ok' : 'fail'} - #{step}".send(ok ? 'green' : 'red') }

exit(results.map(&:last).all? ? 0 : -1)

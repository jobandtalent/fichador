# frozen_string_literal: true

require 'rainbow/refinement'
using Rainbow

def cmd(command, args = '', stop_on_error: false)
  ok = system("#{command} #{args}")

  if !ok && stop_on_error
    puts "FAILED! command: '#{command} #{args}'".red
    exit(1)
  end

  ok
end

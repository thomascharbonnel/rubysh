#!/usr/bin/env ruby

loop do
  begin
    print "> "
    command = gets.chomp

    exit(0) if %w(exit quit).include? command

    puts eval command
  rescue => e
    STDERR.puts e.message
  rescue SyntaxError => e
    STDERR.puts e.message
  end
end

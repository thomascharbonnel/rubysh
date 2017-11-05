#!/usr/bin/env ruby

class Shell
  EXCEPTIONS_TO_CATCH = [ScriptError, StandardError]

  def self.loop
    begin
      print "> "
      command = gets.chomp

      exit(0) if %w(exit quit).include? command

      puts eval command
    rescue *EXCEPTIONS_TO_CATCH => e
      STDERR.puts e.message
    end
  end
end

at_exit do
  # do_something
end

loop do
  Shell.loop
end

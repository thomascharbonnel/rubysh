#!/usr/bin/env ruby

require "readline"

class Shell
  EXCEPTIONS_TO_CATCH = [ScriptError, StandardError]

  def self.loop
    begin
      line = Readline.readline("> ", true)

      exit(0) if %w(exit quit).include? line || line.nil?

      puts eval line
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

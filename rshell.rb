#!/usr/bin/env ruby

require "readline"

module Rubysh
  class Shell
    EXCEPTIONS_CATCH = [ScriptError, StandardError]
    EXCEPTIONS_IGNORE = [Interrupt]
    EXCEPTIONS_EXIT = []

    def self.loop
      begin
        line = Readline.readline("#{Builtin.pwd}> ", true)

        exit(0) if %w(exit quit).include? line || line.nil?
        return if line.empty?

        command, *args = line.split
        if Builtin.respond_to?(command)
          puts Builtin.send(command, *args)
        elsif shell_command?(command)
          puts execute(command, args)[:output]
        else
          puts eval line
        end
      rescue *EXCEPTIONS_CATCH => e
        STDERR.puts e.message
      rescue *EXCEPTIONS_EXIT => e
        STDERR.puts e.message
        exit(1)
      rescue *EXCEPTIONS_IGNORE
      end
    end

    ##
    # Checks if a shell command exists.
    #
    # @param [String] the command to check the existence of.
    # @return [Boolean] whether or not the command is in the PATH.
    def self.shell_command?(command)
      execute("command -v #{command}")[:status] == 0
    end

    ##
    # Returns the output and exit status of a shell command.
    #
    # @param command [String] command to execute.
    # @param *args [Array<String>] optional arguments.
    # @return [Hash{String, Integer}] output and exit status.
    def self.execute(command, *args)
      {
        output: %x(#{command} #{args.join(" ")}),
        status: $?.exitstatus
      }
    end

    class Builtin
      def self.cd(args); Dir.chdir(args); nil; end
      def self.pwd; Dir.pwd; end
    end
  end

  at_exit do
    # do_something
  end

  loop do
    Shell.loop
  end
end


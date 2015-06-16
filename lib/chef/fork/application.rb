#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "logger"
require "optparse"
require "chef/fork/commands"
require "chef/fork/version"

class Chef
  class Fork
    class Application
      def initialize()
        @logger = Logger.new(STDERR)
        @optparse = OptionParser.new
        @optparse.version = Chef::Fork::VERSION
        @options = {
          verbose: false,
        }
        define_options
      end
      attr_reader :options
      attr_reader :optparse

      def main(args=[])
        rest = @optparse.order(args)
        begin
          command = get_command(rest.shift || "help").new(self)
          command.run(rest)
        rescue Errno::EPIPE
          # noop
        end
      end

      private
      def define_options()
        optparse.on("-V", "--[no-]verbose", "Run verbosely") do |value|
          options[:verbose] = value
        end
      end

      def get_command(name)
        class_name = name.to_s.split(/[^\w]+/).map { |s| s.capitalize }.join
        begin
          Chef::Fork::Commands.const_get(class_name)
        rescue NameError
          begin
            require "chef/fork/commands/#{name}"
            Chef::Fork::Commands.const_get(class_name)
          rescue LoadError
            require "chef/fork/commands/help"
            Chef::Fork::Commands::Help
          end
        end
      end
    end
  end
end

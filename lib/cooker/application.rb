#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "logger"
require "optparse"
require "cooker/commands"
require "cooker/version"

module Cooker
  class Application
    def initialize()
      @optparse = OptionParser.new
      @optparse.version = Cooker::VERSION
      @options = {
      }
      define_options
    end

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
    def define_options
    end

    def get_command(name)
      class_name = name.to_s.split(/[^\w]+/).map { |s| s.capitalize }.join
      begin
        Cooker::Commands.const_get(class_name)
      rescue NameError
        begin
          require "cooker/commands/#{name}"
          Cooker::Commands.const_get(class_name)
        rescue LoadError
          require "cooker/commands/help"
          Cooker::Commands::Help
        end
      end
    end
  end
end

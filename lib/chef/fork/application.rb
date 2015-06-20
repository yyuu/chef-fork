#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef"
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
        configure_chef(locate_config_file("fork") || locate_config_file("knife"))
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

      def locate_config_file(name)
        candidate_configs = []
        if ENV.key?("#{name.upcase}_HOME")
          candidate_config << File.join(File.expand_path(ENV["#{name.upcase}_CONFIG"]), "#{name.downcase}.rb")
        end
        candidate_configs << File.expand_path("#{name.downcase}.rb")
        if config_dir = chef_config_dir(Dir.pwd)
          candidate_configs << File.join(config_dir, "#{name.downcase}.rb")
        end
        if ENV.key?("HOME")
          candidate_configs << File.join(File.expand_path(ENV["HOME"]), "#{name.downcase}.rb")
        end
        candidate_configs.find { |candidate_config| File.exist?(candidate_config) }
      end

      def chef_config_dir(path)
        config_dir = File.join(path, ".chef")
        if File.exist?(config_dir)
          return config_dir
        else
          if path == "/"
            return nil
          else
            return chef_config_dir(File.dirname(path))
          end
        end
      end

      def configure_chef(config_file)
        if config_file
          @logger.info("Using configuration from #{config_file}")
          Chef::Config.from_file(config_file)
        else
          @logger.warn("No fork/knife configuration file found")
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

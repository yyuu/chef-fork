#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/rest"

class Chef
  class Fork
    module Commands
      class Noop
        def initialize(application)
          @application = application
          @args = []
          define_options
        end

        def run(args=[])
          @args = @application.optparse.order(args)
          configure(@application.options)
        end

        private
        def define_options()
          command_name = self.class.to_s.split("::").last.scan(/[A-Z][0-9_a-z]*/).join("-").downcase
          optparse.banner = "Usage: #{File.basename($0)} #{command_name} [OPTIONS]"
        end

        def options()
          @application.options
        end

        def optparse()
          @application.optparse
        end

        def configure(options={})
          @application.configure(options)
        end

        def rest()
          @rest ||= Chef::REST.new(Chef::Config[:chef_server_url])
        end
      end
    end
  end
end

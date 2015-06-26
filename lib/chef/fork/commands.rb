#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/rest"

class Chef
  class Fork
    module Commands
      class Noop
        def initialize(application)
          @application = application
          define_options
        end

        def run(args=[])
          order_args(args=[])
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

        def order_args(args=[])
          args = @application.optparse.order(args)
          @application.configure(@application.options)
          args
        end

        def parse_args(args=[])
          args = @application.optparse.parse(args)
          @application.configure(@application.options)
          args
        end

        def rest()
          @rest ||= Chef::REST.new(Chef::Config[:chef_server_url])
        end
      end
    end
  end
end

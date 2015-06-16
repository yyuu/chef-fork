#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Cooker
  module Commands
    class Noop
      def initialize(application)
        @application = application
        @options = {}
        define_options
      end

      def run(args=[])
        rest = @application.optparse.order(args)
      end

      private
      def define_options()
        command_name = self.class.to_s.split("::").last.scan(/[A-Z][0-9_a-z]*/).join("-").downcase
        optparse.banner = "Usage: #{File.basename($0)} #{command_name} [OPTIONS]"
      end

      def optparse()
        @application.optparse
      end
    end
  end
end

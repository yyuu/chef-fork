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
      end

      def optparse()
        @application.optparse
      end
    end
  end
end

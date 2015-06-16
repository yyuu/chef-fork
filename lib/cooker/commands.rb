#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module Cooker
  module Commands
    class Noop
      def initialize(application)
        @application = application
      end

      def run(args=[])
      end
    end
  end
end

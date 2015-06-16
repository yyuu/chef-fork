#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rbconfig"
require "cooker/commands"

module Cooker
  module Commands
    class Help < Noop
      def run(args=[])
        ruby = File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"])
        exit(system(ruby, $0, "--help") ? 0 : 1)
      end
    end
  end
end

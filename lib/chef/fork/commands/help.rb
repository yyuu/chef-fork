#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rbconfig"
require "chef/fork/commands"

class Chef
  class Fork
    module Commands
      class Help < Noop
        def run(args=[])
          ruby = File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"])
          exit(system(ruby, $0, "--help") ? 0 : 1)
        end
      end
    end
  end
end

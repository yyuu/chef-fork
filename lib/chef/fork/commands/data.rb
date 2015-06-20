#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"

class Chef
  class Fork
    module Commands
      class Data < Noop
        def run(args=[])
          raise(NotImplementedError)
        end
      end
    end
  end
end

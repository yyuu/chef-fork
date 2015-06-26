#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands/data"

class Chef
  class Fork
    module Commands
      class Databag < Data
        def run(args=[])
          super
          data_bag(@args)
        end
      end
    end
  end
end

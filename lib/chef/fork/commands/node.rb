#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"
require "chef/node"
require "json"

class Chef
  class Fork
    module Commands
      class Node < Noop
        def run(args=[])
          rest = optparse.order(args)
          case rest.first
          when "show"
            node_show(rest.slice(1..-1) || [])
          else
            raise(NameError.new(rest.inspect))
          end
        end

        private
        def node_show(args=[])
          args.each do |node_name|
            node = Chef::Node.load(node_name)
            STDOUT.puts(JSON.pretty_generate(node.to_hash()))
          end
        end
      end
    end
  end
end

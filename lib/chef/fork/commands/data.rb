#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"

class Chef
  class Fork
    module Commands
      class Data < Noop
        def run(args=[])
          rest = optparse.order(args)
          case rest.first
          when "bag"
            data_bag(rest.slice(1..-1) || [])
          else
            raise(NameError.new(rest.inspect))
          end
        end

        private
        def data_bag(args=[])
          case args.first
          when "from"
            data_bag_from(args.slice(1..-1) || [])
          when "show"
            data_bag_show(args.slice(1..-1) || [])
          else
            raise(NameError.new(args.inspect))
          end
        end

        def data_bag_from(args=[])
          case args.first
          when "file"
            data_bag_from_file(args.slice(1..-1) || [])
          else
            raise(NameError.new(args.inspect))
          end
        end

        def data_bag_from_file(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def data_bag_show(args=[])
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands/data"

class Chef
  class Fork
    module Commands
      class Databag < Data
        def run(args=[])
          data_bag(args)
        end

        private
        def data_bag(args=[])
          case args.first
          when "from"
            data_bag_from(args.slice(1..-1))
          when "show"
            data_bag_show(args.slice(1..-1))
          else
            raise(NameError.new(args.inspect))
          end
        end

        def data_bag_from(args=[])
          case args.first
          when "file"
            data_bag_from_file(args.slice(1..-1))
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

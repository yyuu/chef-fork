#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"

class Chef
  class Fork
    module Commands
      class Environment < Noop
        def run(args=[])
          case args.first
          when "from"
            environment_from(args.slice(1..-1))
          when "show"
            environment_show(args.slice(1..-1))
          else
            raise(NameError.new(args.inspect))
          end
        end

        private
        def environment_from(args=[])
          case args.first
          when "file"
            environment_from_file(args.slice(1..-1))
          else
            raise(NameError.new(args.inspect))
          end
        end

        def environment_from_file(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def environment_show(args=[])
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

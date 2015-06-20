#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"

class Chef
  class Fork
    module Commands
      class Role < Noop
        def run(args=[])
          case args.first
          when "from"
            role_from(args.slice(1..-1))
          when "show"
            role_show(args.slice(1..-1))
          else
            raise(NameError.new(args.inspect))
          end
        end

        def role_from(args=[])
          case args.shift
          when "file"
            rome_from_file(args.slice(1..-1))
          else
            raise(NameError.new(args.inspect))
          end
        end

        def role_from_file(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def role_show(args=[])
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

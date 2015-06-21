#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"
require "chef/role"
require "json"

class Chef
  class Fork
    module Commands
      class Role < Noop
        def run(args=[])
          rest = optparse.order(args)
          case rest.first
          when "from"
            role_from(rest.slice(1..-1) || [])
          when "show"
            role_show(rest.slice(1..-1) || [])
          else
            raise(NameError.new(rest.inspect))
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
          args.each do |role_name|
            role = Chef::Role.load(role_name)
            STDOUT.puts(JSON.pretty_generate(role_to_hash(role.to_hash())))
          end
        end
      end
    end
  end
end

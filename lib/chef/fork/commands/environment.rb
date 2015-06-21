#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/environment"
require "chef/fork/commands"
require "json"

class Chef
  class Fork
    module Commands
      class Environment < Noop
        def run(args=[])
          rest = optparse.order(args)
          case rest.first
          when "edit"
            environment_edit(rest.slice(1..-1) || [])
          when "from"
            environment_from(rest.slice(1..-1) || [])
          when "list"
            environment_list(rest.slice(1..-1) || [])
          when "show"
            environment_show(rest.slice(1..-1) || [])
          else
            raise(NameError.new(rest.inspect))
          end
        end

        private
        def environment_edit(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def environment_from(args=[])
          case args.first
          when "file"
            environment_from_file(args.slice(1..-1) || [])
          else
            raise(NameError.new(args.inspect))
          end
        end

        def environment_from_file(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def environment_list(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def environment_show(args=[])
          args.each do |environment_name|
            environment = Chef::Environment.load(environment_name)
            STDOUT.puts(JSON.pretty_generate(environment_to_hash(environment.to_hash())))
          end
        end
      end
    end
  end
end

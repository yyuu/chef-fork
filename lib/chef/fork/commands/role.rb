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
          when "edit"
            role_edit(rest.slice(1..-1) || [])
          when "from"
            role_from(rest.slice(1..-1) || [])
          when "list"
            role_list(rest.slice(1..-1) || [])
          when "show"
            role_show(rest.slice(1..-1) || [])
          when "upload"
            role_upload(rest.slice(1..-1) || [])
          else
            raise(NameError.new(rest.inspect))
          end
        end

        private
        def role_edit(args=[])
          raise(NotImplementedError.new(args.inspect))
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
          role_upload(args)
        end

        def role_list(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def role_show(args=[])
          args.each do |role_name|
            role = Chef::Role.load(role_name)
            STDOUT.puts(JSON.pretty_generate(role_to_hash(role.to_hash())))
          end
        end

        def role_upload(args=[])
          role_paths = [ Chef::Config[:role_path] ].flatten
          args.each do |role_name|
            candidates = role_paths.map { |path| File.join(path, "#{role_name}.rb") }
            if file = candidates.select { |candidate| File.exist?(candidate) }.first
              role = Chef::Role.from_disk(role_name)
              p(role) # TODO: do upload
            end
          end
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

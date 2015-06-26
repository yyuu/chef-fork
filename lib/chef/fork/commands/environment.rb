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
          super
          case @args.first
          when "edit"
            environment_edit(@args.slice(1..-1) || [])
          when "from"
            environment_from(@args.slice(1..-1) || [])
          when "list"
            environment_list(@args.slice(1..-1) || [])
          when "show"
            environment_show(@args.slice(1..-1) || [])
          when "upload"
            environment_upload(@args.slice(1..-1) || [])
          else
            raise(NameError.new(@args.inspect))
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
          environment_upload(args)
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

        def environment_upload(args=[])
          environment_paths = [ Chef::Config[:environment_path] ].flatten
          args.each do |environment_name|
            candidates = environment_paths.map { |path| File.join(path, "#{environment_name}.rb") }
            if file = candidates.select { |candidate| File.exist?(candidate) }.first
              environment = Chef::Environment.load_from_file(environment_name)
              p(environment) # TODO: do upload
            end
          end
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

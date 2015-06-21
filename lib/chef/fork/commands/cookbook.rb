#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"
require "json"

class Chef
  class Fork
    module Commands
      class Cookbook < Noop
        def run(args=[])
          rest = optparse.order(args)
          case rest.first
          when "edit"
            cookbook_edit(rest.slice(1..-1) || [])
          when "list"
            cookbook_list(rest.slice(1..-1) || [])
          when "show"
            cookbook_show(rest.slice(1..-1) || [])
          when "upload"
            cookbook_upload(rest.slice(1..-1) || [])
          else
            raise(NameError.new(rest.inspect))
          end
        end

        private
        def cookbook_edit(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def cookbook_list(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def cookbook_show(args=[])
          if cookbook_name = args.shift
            if args.empty?
              cookbook_version = "_latest"
              STDOUT.puts(JSON.pretty_generate(@rest.get_rest("cookbooks/#{cookbook_name}/#{cookbook_version}").to_hash()))
            else
              args.each do |cookbook_version|
                STDOUT.puts(JSON.pretty_generate(@rest.get_rest("cookbooks/#{cookbook_name}/#{cookbook_version}").to_hash()))
              end
            end
          end
        end

        def cookbook_upload(args=[])
          cookbook_paths = [ Chef::Config[:cookbook_path] ].flatten
          args.each do |cookbook_name|
            candidates = cookbook_paths.map { |path| File.join(path, cookbook_name) }
            if file = candidates.select { |candidate| File.exist?(candidate) }.first
              p([cookbook_name, file])
            end
          end
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

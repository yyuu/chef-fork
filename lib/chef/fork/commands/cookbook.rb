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
          when "show"
            cookbook_show(rest.slice(1..-1) || [])
          when "upload"
            cookbook_upload(rest.slice(1..-1) || [])
          else
            raise(NameError.new(rest.inspect))
          end
        end

        private
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
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

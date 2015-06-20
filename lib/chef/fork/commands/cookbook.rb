#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"

class Chef
  class Fork
    module Commands
      class Cookbook < Noop
        def run(args=[])
          case args.first
          when "show"
            cookbook_show(args.slice(1..-1))
          when "upload"
            cookbook_upload(args.slice(1..-1))
          else
            raise(NameError.new(args.inspect))
          end
        end

        private
        def cookbook_show(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def cookbook_upload(args=[])
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

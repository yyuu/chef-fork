#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/commands"
require "json"
require "rbconfig"

class Chef
  class Fork
    module Commands
      class Help < Noop
        def run(args=[])
          super
          rest = @args.dup
          if command = rest.shift
            case command
            when "commands"
              paths = $LOAD_PATH.map { |path|
                File.join(path, "chef", "fork", "commands")
              }
              commands = paths.map { |path|
                Dir.glob(File.join(path, "*.rb")).map { |file| File.basename(file, ".rb") }
              }.flatten
              STDOUT.puts(JSON.pretty_generate(commands.sort.uniq))
            else
              raise(NotImplementedError.new(command.inspect))
            end
          else
            ruby = File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"])
            exec(ruby, $0, "--help")
            exit(127)
          end
        end
      end
    end
  end
end

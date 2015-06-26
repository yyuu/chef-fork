#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/data_bag"
require "chef/data_bag_item"
require "chef/fork/commands"
require "json"

class Chef
  class Fork
    module Commands
      class Data < Noop
        def run(args=[])
          rest = order_args(args)
          case rest.first
          when "bag"
            data_bag(rest.slice(1..-1) || [])
          else
            raise(NameError.new(rest.inspect))
          end
        end

        private
        def data_bag(args=[])
          case args.first
          when "edit"
            data_bag_edit(args.slice(1..-1) || [])
          when "from"
            data_bag_from(args.slice(1..-1) || [])
          when "list"
            data_bag_list(args.slice(1..-1) || [])
          when "show"
            data_bag_show(args.slice(1..-1) || [])
          when "upload"
            data_bag_upload(args.slice(1..-1) || [])
          else
            raise(NameError.new(args.inspect))
          end
        end

        def data_bag_edit(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def data_bag_from(args=[])
          case args.first
          when "file"
            data_bag_from_file(args.slice(1..-1) || [])
          else
            raise(NameError.new(args.inspect))
          end
        end

        def data_bag_from_file(args=[])
          data_bag_uploda(args)
        end

        def data_bag_list(args=[])
          raise(NotImplementedError.new(args.inspect))
        end

        def data_bag_show(args=[])
          if data_bag_name = args.shift
            if args.empty?
              data_bag = Chef::DataBag.load(data_bag_name)
              STDOUT.puts(JSON.pretty_generate(data_bag.to_hash()))
            else
              args.each do |data_bag_item_name|
                data_bag_item = Chef::DataBagItem.load(data_bag_name, data_bag_item_name)
                STDOUT.puts(JSON.pretty_generate(data_bag_item.to_hash()))
              end
            end
          end
        end

        def data_bag_upload(args=[])
          data_bag_paths = [ Chef::Config[:data_bag_path] ].flatten
          if data_bag_name = args.shift
            args.each do |data_bag_item_name|
              candidates = data_bag_paths.map { |path| File.join(path, data_bag_name, "#{data_bag_item_name}.json") }
              if file = candidates.select { |candidate| File.exist?(candidate) }.first
                data_bag_item = Chef::DataBagItem.from_hash(JSON.load(File.read(file)))
                p(data_bag_item) # TODO: do upload
              end
            end
          end
          raise(NotImplementedError.new(args.inspect))
        end
      end
    end
  end
end

#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef"
require "chef/knife/core/bootstrap_context"
require "erubis"
require "json"
require "shellwords"
require "chef/fork/commands/ssh"

class Chef
  class Fork
    module Commands
      class Bootstrap < Ssh
        def run(args=[])
          rest = parse_args(args)
          if hostname = rest.shift
            command = bootstrap_command()
            ssh(hostname, [command])
          end
        end

        private
        def define_options
          super
          options.merge!({
            distro: "chef-full",
            first_boot_attributes: {},
            run_list: [],
            use_sudo: true,
          })

          optparse.on("-N NAME", "--node-name NAME", "The Chef node name for new node") do |value|
            options[:chef_node_name] = value
          end

          optparse.on("--bootstrap-version VERSION", "The version of Chef to install") do |value|
            options[:bootstrap_version] = value
          end

          optparse.on("--bootstrap-proxy PROXY_URL", "The proxy server for the node being bootstrapped") do |value|
            options[:bootstrap_proxy] = value
          end

          optparse.on("-d DISTRO", "--distro DISTRO", "Bootstrap a distro using a template") do |value|
            options[:distro] = value
          end

          optparse.on("--sudo", "Execute the bootstrap via sudo") do |value|
            options[:use_sudo] = value
          end

          optparse.on("--template-file TEMPLATE", "Full path to location of template to use") do |value|
            options[:template_file] = value
          end

          optparse.on("-r RUN_LIST", "--run-list RUN_LIST", "Comma separated list of roles/recipes to apply") do |value|
            options[:run_list] += value.split(",").map { |s| s.strip }
          end

          optparse.on("-j JSON_ATTRIBS", "--json-attributes JSON_ATTRIBS", "A JSON string to be added to the first run of chef-client") do |value|
            options[:first_boot_attributes] = options[:first_boot_attributes].merge(JSON.parse(value))
          end

          optparse.on("-s SECRET", "--secret SECRET", "The secret key to use to encrypt data bag item values") do |value|
            options[:secret] = value
          end

          optparse.on("--secret-file SECRET_FILE", "A file containing the secret key to use to encrypt data bag item values") do |value|
            options[:secret_file] = value
          end
        end

        def bootstrap_command()
          template_file = options[:template_file] || find_template(options[:distro])
          if template_file
            template = File.read(template_file)
            command = render_template(template)
            if options[:use_sudo]
              "sudo #{command}"
            else
              command
            end
          else
            raise(NameError.new("Unknown distro: #{options[:distro].inspect}"))
          end
        end

        def find_template(name)
          templates = $LOAD_PATH.map { |path|
            [
              File.join(path, "chef", "knife", "bootstrap", "templates", "#{name}.erb"), # Chef 12.x
              File.join(path, "chef", "knife", "bootstrap", "#{name}.erb"), # Chef 11.x
            ]
          }.reduce(:+)
          templates.find { |path| File.exist?(path) }
        end

        def render_template(template)
          context = Chef::Knife::Core::BootstrapContext.new(options, options[:run_list], Chef::Config)
          Erubis::Eruby.new(template).evaluate(context)
        end
      end
    end
  end
end

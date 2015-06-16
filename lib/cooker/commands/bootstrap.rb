#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef"
require "erb"
require "json"
require "shellwords"
require "cooker/commands/ssh"

module Cooker
  module Commands
    class Bootstrap < Ssh
      def run(args=[])
        rest = optparse.order(args)
        if options[:distro]
          if template_file = find_template(options[:distro])
            template = File.read(template_file)
            command = render_template(template)
            hostname = rest.shift
#           ssh(hostname, command) # TODO
            STDOUT.puts(command)
          else
            raise(NameError.new("Unknown distro: #{options[:distro].inspect}"))
          end
        end
      end

      private
      def define_options
        super
        options.merge!({
          distro: "chef-full",
          use_sudo: true,
          use_sudo_password: false,
          run_list: [],
          first_boot_attributes: {},
        })
        optparse.on("-N NAME", "--node-name NAME", "The Chef node name for new node") do |value|
          options[:chef_node_name] = value
        end

        optparse.on("--bootstrap-version VERSION", "The version of Chef to install") do |value|
          options[:bootstrap_version] = value
        end

        optparse.on("-d DISTRO", "--distro DISTRO", "Bootstrap a distro using a template") do |value|
          options[:distro] = value
        end

        optparse.on("--sudo", "Execute the bootstrap via sudo") do |value|
          options[:use_sudo] = value
        end

        optparse.on("--use-sudo-password", "Execute the bootstrap via sudo with password") do |value|
          options[:use_sudo_password] = value
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

      def find_template(name)
        templates = $LOAD_PATH.map { |path| File.join(path, "chef", "knife", "bootstrap", "templates", "#{options[:distro]}.erb") }
        templates.select { |template| File.exist?(template) }.first
      end

      def render_template(template)
        @chef_config = { # FIXME
          :knife => {
          },
        }
        Erubis::Eruby.new(template).evaluate(self)
      end

      def knife_config() # FIXME
        @chef_config.fetch(:knife, {})
      end

      def chef_version() # FIXME
        options.fetch(:bootstrap_version, Chef::VERSION)
      end

      def latest_current_chef_version_string() # FIXME
        chef_version
      end

      def client_pem() # FIXME
        nil
      end

      def validation_key() # FIXME
        nil
      end

      def encrypted_data_bag_secret() # FIXME
        if options[:secret]
          options[:secret]
        else
          if options[:secret_file]
            File.read(options[:secret_file])
          else
            nil
          end
        end
      end

      def trusted_certs() # FIXME
        []
      end

      def config_content() # FIXME
        ""
      end

      def first_boot() # FIXME
        options[:first_boot_attributes].merge(:run_list => options[:run_list])
      end

      def start_chef() # FIXME
        chef_options = []
        chef_options << "-j" << "/etc/chef/first-boot.json"
        chef_options << "-l" << "debug" if options[:verbose]
        chef_options << "-E" << bootstrap_environment
        "chef-client #{Shellwords.shelljoin(chef_options)}"
      end

      def bootstrap_environment() # FIXME
        @chef_config.fetch(:environment, "_default")
      end
    end
  end
end

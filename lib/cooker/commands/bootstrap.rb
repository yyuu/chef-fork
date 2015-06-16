#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "json"
require "cooker/commands"

module Cooker
  module Commands
    class Bootstrap < Noop
      def initialize(application)
        super
        optparse.banner = "Usage: #{File.basename($0)} #{File.basename(__FILE__, ".rb")} [OPTIONS]"
      end

      def run(args=[])
        rest = optparse.order(args)
      end

      private
      def define_options
        @options = @options.merge({
          ssh_user: "root",
          distro: "chef-full",
          use_sudo: true,
          use_sudo_password: false,
          run_list: [],
          first_boot_attributes: {},
          host_key_verify: true,
        })
        optparse.on("-x USERNAME", "--ssh-user USERNAME", "The ssh username") do |value|
          @options[:ssh_user] = value
        end

        optparse.on("-P PASSWORD", "--ssh-password PASSWORD", "The ssh password") do |value|
          @options[:ssh_password] = value
        end

        optparse.on("-p PORT", "--ssh-port PORT", "The ssh port") do |value|
          @options[:ssh_port] = value
        end

        optparse.on("-G GATEWAY", "--ssh-gateway GATEWAY", "The ssh gateway") do |value|
          @options[:ssh_gateway] = value
        end

        optparse.on("-i IDENTITY_FILE", "--identity-file IDENTITY_FILE") do |value|
          @options[:identity_file] = value
        end

        optparse.on("-N NAME", "--node-name NAME", "The Chef node name for new node") do |value|
          @options[:chef_node_name] = value
        end

        optparse.on("--bootstrap-version VERSION", "The version of Chef to install") do |value|
          @options[:bootstrap_version] = value
        end

        optparse.on("-d DISTRO", "--distro DISTRO", "Bootstrap a distro using a template") do |value|
          @options[:distro] = value
        end

        optparse.on("--sudo", "Execute the bootstrap via sudo") do |value|
          @options[:use_sudo] = value
        end

        optparse.on("--use-sudo-password", "Execute the bootstrap via sudo with password") do |value|
          @options[:use_sudo_password] = value
        end

        optparse.on("-r RUN_LIST", "--run-list RUN_LIST", "Comma separated list of roles/recipes to apply") do |value|
          @options[:run_list] += value.split(",").map { |s| s.strip }
        end

        optparse.on("-j JSON_ATTRIBS", "--json-attributes JSON_ATTRIBS", "A JSON string to be added to the first run of chef-client") do |value|
          @options[:first_boot_attributes] = @options[:first_boot_attributes].merge(JSON.parse(value))
        end

        optparse.on("--[no-]host-key-verify", "Verify host key, enabled by default") do |value|
          @options[:host_key_verify] = value
        end

        optparse.on("-s SECRET", "--secret SECRET", "The secret key to use to encrypt data bag item values") do |value|
          @options[:secret] = value
        end

        optparse.on("--secret-file SECRET_FILE", "A file containing the secret key to use to encrypt data bag item values") do |value|
          @options[:secret_file] = value
        end
      end
    end
  end
end

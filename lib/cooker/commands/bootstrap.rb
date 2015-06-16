#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "json"
require "cooker/commands/ssh"

module Cooker
  module Commands
    class Bootstrap < Ssh
      def run(args=[])
        rest = optparse.order(args)
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
    end
  end
end

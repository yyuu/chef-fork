#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "cooker/commands"

module Cooker
  module Commands
    class Ssh < Noop
      def run(args=[])
        rest = optparse.order(args)
      end

      private
      def define_options
        super
        @options = @options.merge({
          ssh_user: "root",
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

        optparse.on("--[no-]host-key-verify", "Verify host key, enabled by default") do |value|
          @options[:host_key_verify] = value
        end
      end
    end
  end
end

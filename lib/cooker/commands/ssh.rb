#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "shellwords"
require "cooker/commands"

module Cooker
  module Commands
    class Ssh < Noop
      def run(args=[])
        rest = optparse.order(args)
        hostname = rest.shift
        exec(ssh_command(hostname, rest))
        exit(127)
      end

      private
      def define_options
        super
        options.merge!({
          ssh_user: "root",
          host_key_verify: true,
        })
        optparse.on("-x USERNAME", "--ssh-user USERNAME", "The ssh username") do |value|
          options[:ssh_user] = value
        end

        optparse.on("-P PASSWORD", "--ssh-password PASSWORD", "The ssh password") do |value|
          options[:ssh_password] = value
        end

        optparse.on("-p PORT", "--ssh-port PORT", "The ssh port") do |value|
          options[:ssh_port] = value
        end

        optparse.on("-G GATEWAY", "--ssh-gateway GATEWAY", "The ssh gateway") do |value|
          options[:ssh_gateway] = value
        end

        optparse.on("-i IDENTITY_FILE", "--identity-file IDENTITY_FILE") do |value|
          options[:identity_file] = value
        end

        optparse.on("--[no-]host-key-verify", "Verify host key, enabled by default") do |value|
          options[:host_key_verify] = value
        end
      end

      def ssh_command(hostname, args=[])
        ssh_options = [
          "-F",
          "/dev/null",
        ]

        if options[:ssh_user]
          ssh_options << "-l"
          ssh_options << options[:ssh_user]
        end

        if options[:ssh_password]
          raise(NotImplementedError)
        end

        if options[:ssh_port]
          ssh_options << "-p"
          ssh_options << options[:ssh_port]
        end

        if options[:ssh_gateway]
          proxy_host_port, proxy_user = options[:ssh_gateway].split("@", 2).reverse
          proxy_host, proxy_port = proxy_host_port.split(":", 2)
          if not proxy_user and options[:ssh_user]
            proxy_user = options[:ssh_user]
          end
          proxy_options = [
            "-F",
            "/dev/null",
          ]
          proxy_options << "-W" << "%h:%p"
          if options[:identity_file]
            proxy_options << "-i" << options[:identity_file]
          end
          if proxy_user
            proxy_options << "-l" << proxy_user
          end
          if proxy_port
            proxy_options << "-p" << proxy_port
          end
          if not options[:host_key_verify]
            proxy_options << "-o" << "UserKnownHostsFile=/dev/null"
            proxy_options << "-o" << "StrictHostKeyChecking=no"
          end
          ssh_options << "-o" << "ProxyCommand=ssh #{Shellwords.shelljoin(proxy_options)} #{Shellwords.shellescape(proxy_host)}"
        end

        if options[:identity_file]
          ssh_options << "-i"
          ssh_options << options[:identity_file]
        end

        if not options[:host_key_verify]
          ssh_options << "-o" << "UserKnownHostsFile=/dev/null"
          ssh_options << "-o" << "StrictHostKeyChecking=no"
        end

        if options[:verbose]
          ssh_options << "-v"
        end

        if args.empty?
          "ssh #{Shellwords.shelljoin(ssh_options)} #{Shellwords.shellescape(hostname)}"
        else
          "ssh #{Shellwords.shelljoin(ssh_options)} #{Shellwords.shellescape(hostname)} -- #{Shellwords.shelljoin(args)}"
        end
      end
    end
  end
end

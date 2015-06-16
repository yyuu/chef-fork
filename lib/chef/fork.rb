#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/fork/application"

class Chef
  class Fork
    def initialize()
      @application = Chef::Fork::Application.new()
    end

    def main(args=[])
      @application.main(args)
    end
  end
end

# vim:set ft=ruby :

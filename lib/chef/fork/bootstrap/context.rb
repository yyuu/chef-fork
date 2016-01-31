#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "chef/knife/core/bootstrap_context"

class Chef
  class Fork
    module Bootstrap
      class Context < ::Chef::Knife::Core::BootstrapContext
      end
    end
  end
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef/fork/version'

Gem::Specification.new do |spec|
  spec.name          = "chef-fork"
  spec.version       = Chef::Fork::VERSION
  spec.authors       = ["Yamashita Yuu"]
  spec.email         = ["peek824545201@gmail.com"]

  spec.summary       = %q{A tool for your left hand, to have a meal cooked by chef.}
  spec.description   = %q{A tool for your left hand, to have a meal cooked by chef.}
  spec.homepage      = "https://github.com/yyuu/chef-fork"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "chef", ">= 11.18.0"
  spec.add_dependency "erubis", ">= 2.7"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_memory_bloat/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_memory_bloat"
  spec.version       = RailsMemoryBloat::VERSION
  spec.authors       = ["Peter Woo", "Sudara Williams"]
  spec.email         = ["team@rubytune.com "]

  spec.summary       = %q{Logs memory usage and Active Record instantiations in Rails apps}
  spec.homepage      = "https://github.com/rubytune/rails_memory_bloat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = ['build_memory_report']
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rails', '>= 3.0.0'
  spec.add_runtime_dependency "active-record-instance-count"
  spec.add_runtime_dependency "get_process_mem"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end

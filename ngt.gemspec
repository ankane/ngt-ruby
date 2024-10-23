require_relative "lib/ngt/version"

Gem::Specification.new do |spec|
  spec.name          = "ngt"
  spec.version       = Ngt::VERSION
  spec.summary       = "High-speed approximate nearest neighbors for Ruby"
  spec.homepage      = "https://github.com/ankane/ngt-ruby"
  spec.license       = "Apache-2.0"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib,vendor}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "ffi"
end

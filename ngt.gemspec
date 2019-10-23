require_relative "lib/ngt/version"

Gem::Specification.new do |spec|
  spec.name          = "ngt"
  spec.version       = Ngt::VERSION
  spec.summary       = "NGT - high-speed approximate nearest neighbors - for Ruby"
  spec.homepage      = "https://github.com/ankane/ngt"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{ext,lib,vendor}/**/*"]
  spec.require_path  = "lib"
  spec.extensions    = ["ext/ngt/extconf.rb"]

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "ffi"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", ">= 5"
  spec.add_development_dependency "numo-narray"
  spec.add_development_dependency "rake-compiler"
end

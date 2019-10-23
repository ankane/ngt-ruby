# dependencies
require "ffi"

# modules
require "ngt/index"
require "ngt/version"

module Ngt
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  self.ffi_lib = [File.expand_path("ngt.bundle", __dir__)]

  # friendlier error message
  autoload :FFI, "ngt/ffi"
end

# dependencies
require "fiddle/import"

# modules
require "ngt/index"
require "ngt/version"

module Ngt
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  self.ffi_lib = ["libngt.dylib", "libngt.so", "ngt.dll"]

  # friendlier error message
  autoload :FFI, "ngt/ffi"
end

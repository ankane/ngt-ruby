# dependencies
require "ffi"

# modules
require "ngt/utils"
require "ngt/index"
require "ngt/optimizer"
require "ngt/version"

module Ngt
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  lib_name = FFI.map_library_name("ngt")
  vendor_lib = File.expand_path("../vendor/#{lib_name}", __dir__)
  self.ffi_lib = [vendor_lib]

  # friendlier error message
  autoload :FFI, "ngt/ffi"
end

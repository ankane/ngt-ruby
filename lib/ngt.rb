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
  self.ffi_lib =
    case RbConfig::CONFIG["host_os"]
    when /mingw|mswin/i
      ["ngt.dll"]
    when /darwin/i
      ["libngt.dylib"]
    else
      ["libngt.so"]
    end

  # friendlier error message
  autoload :FFI, "ngt/ffi"
end

# dependencies
require "ffi"

# stdlib
require "tmpdir"

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
  lib_name =
    if RbConfig::CONFIG["host_os"] =~ /darwin/i && RbConfig::CONFIG["host_cpu"] =~ /arm/i
      FFI.map_library_name("ngt.arm64")
    else
      FFI.map_library_name("ngt")
    end
  vendor_lib = File.expand_path("../vendor/#{lib_name}", __dir__)
  self.ffi_lib = [vendor_lib]

  # friendlier error message
  autoload :FFI, "ngt/ffi"
end

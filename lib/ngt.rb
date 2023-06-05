# dependencies
require "ffi"

# stdlib
require "tmpdir"

# modules
require_relative "ngt/utils"
require_relative "ngt/index"
require_relative "ngt/optimizer"
require_relative "ngt/version"

module Ngt
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  lib_path =
    if Gem.win_platform?
      "x64-mingw/ngt.dll"
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
        "arm64-darwin/libngt.dylib"
      else
        "x86_64-darwin/libngt.dylib"
      end
    else
      if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
        "aarch64-linux/libngt.so"
      else
        "x86_64-linux/libngt.so"
      end
    end
  vendor_lib = File.expand_path("../vendor/#{lib_path}", __dir__)
  self.ffi_lib = [vendor_lib]

  # friendlier error message
  autoload :FFI, "ngt/ffi"
end

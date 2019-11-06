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
  self.ffi_lib = ["ngt"]

  # friendlier error message
  autoload :FFI, "ngt/ffi"
end

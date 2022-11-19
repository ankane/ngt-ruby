module Ngt
  module Utils
    # private
    def self.ffi(method, *args)
      res = FFI.send(method, *args)
      message = FFI.ngt_get_error_string(args.last)
      unless message.empty?
        FFI.ngt_clear_error_string(args.last)
        raise Error, message
      end
      res
    end

    private

    def ffi(*args)
      Utils.ffi(*args, @error)
    end
  end
end

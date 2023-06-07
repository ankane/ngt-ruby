module Ngt
  class Optimizer
    include Utils

    def initialize(outgoing: 10, incoming: 120, queries: 100, low_accuracy_from: 0.3, low_accuracy_to: 0.5, high_accuracy_from: 0.8, high_accuracy_to: 0.9, gt_epsilon: 0.1, merge: 0.2)
      @error = FFI.ngt_create_error_object
      ObjectSpace.define_finalizer(@error, self.class.finalize_error(@error.to_i))

      @optimizer = ffi(:ngt_create_optimizer, true)
      ObjectSpace.define_finalizer(@optimizer, self.class.finalize_optimizer(@optimizer.to_i))

      ffi(:ngt_optimizer_set, @optimizer, outgoing, incoming, queries, low_accuracy_from,
        low_accuracy_to, high_accuracy_from, high_accuracy_to, gt_epsilon, merge)
    end

    def execute(in_index_path, out_index_path)
      ffi(:ngt_optimizer_execute, @optimizer, path(in_index_path), out_index_path)
    end

    def adjust_search_coefficients(index_path)
      ffi(:ngt_optimizer_adjust_search_coefficients, @optimizer, path(index_path))
    end

    def self.finalize_optimizer(addr)
      # must use proc instead of stabby lambda
      proc { FFI.ngt_destroy_optimizer(::FFI::Pointer.new(:pointer, addr)) }
    end

    def self.finalize_error(addr)
      # must use proc instead of stabby lambda
      proc { FFI.ngt_destroy_error_object(::FFI::Pointer.new(:pointer, addr)) }
    end

    private

    def path(obj)
      if obj.is_a?(Ngt::Index)
        raise ArgumentError, "Index not saved" unless obj.path
        obj.path
      else
        obj
      end
    end
  end
end

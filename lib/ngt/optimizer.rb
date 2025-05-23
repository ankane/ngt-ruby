module Ngt
  class Optimizer
    include Utils

    def initialize(outgoing: 10, incoming: 120, queries: 100, low_accuracy_from: 0.3, low_accuracy_to: 0.5, high_accuracy_from: 0.8, high_accuracy_to: 0.9, gt_epsilon: 0.1, merge: 0.2)
      @error = FFI.ngt_create_error_object
      @error = ::FFI::AutoPointer.new(@error, FFI.method(:ngt_destroy_error_object))

      @optimizer = ffi(:ngt_create_optimizer, true)
      @optimizer = ::FFI::AutoPointer.new(@optimizer, FFI.method(:ngt_destroy_optimizer))

      ffi(:ngt_optimizer_set, @optimizer, outgoing, incoming, queries, low_accuracy_from,
        low_accuracy_to, high_accuracy_from, high_accuracy_to, gt_epsilon, merge)
    end

    def execute(in_index_path, out_index_path)
      ffi(:ngt_optimizer_execute, @optimizer, path(in_index_path), out_index_path)
    end

    def adjust_search_coefficients(index_path)
      ffi(:ngt_optimizer_adjust_search_coefficients, @optimizer, path(index_path))
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

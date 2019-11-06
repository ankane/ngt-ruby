module Ngt
  class Optimizer
    include Utils

    def initialize(outgoing: 10, incoming: 120, queries: 100, low_accuracy_from: 0.3, low_accuracy_to: 0.5, high_accuracy_from: 0.8, high_accuracy_to: 0.9, gt_epsilon: 0.1, merge: 0.2)
      raise Error, "Upgrade to NGT 1.8.1+ to use the optimizer" unless FFI.respond_to?(:ngt_create_optimizer)

      @error = FFI.ngt_create_error_object
      @optimizer = ffi(:ngt_create_optimizer, true)

      ffi(:ngt_optimizer_set, @optimizer, outgoing, incoming, queries, low_accuracy_from,
        low_accuracy_to, high_accuracy_from, high_accuracy_to, gt_epsilon, merge)

      ObjectSpace.define_finalizer(self, self.class.finalize(@optimizer, @error))
    end

    def execute(in_index_path, out_index_path)
      ffi(:ngt_optimizer_execute, @optimizer, in_index_path, out_index_path)
    end

    def adjust_search_coefficients(index_path)
      ffi(:ngt_optimizer_adjust_search_coefficients, @optimizer, index_path)
    end

    def self.finalize(optimizer, error)
      # must use proc instead of stabby lambda
      proc do
        FFI.ngt_destroy_optimizer(optimizer)
        FFI.ngt_destroy_error_object(error)
      end
    end
  end
end

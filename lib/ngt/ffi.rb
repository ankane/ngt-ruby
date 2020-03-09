module Ngt
  module FFI
    extend ::FFI::Library

    ffi_lib Ngt.ffi_lib

    # https://github.com/yahoojapan/NGT/blob/master/lib/NGT/Capi.h
    # keep same order

    # use uint32 instead of uint32_t
    # to prevent "unable to resolve type" error on Ubuntu

    class ObjectDistance < ::FFI::Struct
      layout :id, :int,
        :distance, :float
    end

    attach_function :ngt_open_index, %i[string pointer], :pointer
    attach_function :ngt_create_graph_and_tree, %i[string pointer pointer], :pointer
    attach_function :ngt_create_graph_and_tree_in_memory, %i[pointer pointer], :pointer
    attach_function :ngt_create_property, %i[pointer], :pointer
    attach_function :ngt_save_index, %i[pointer string pointer], :bool
    attach_function :ngt_get_property, %i[pointer pointer pointer], :bool
    attach_function :ngt_get_property_dimension, %i[pointer pointer], :int32_t
    attach_function :ngt_set_property_dimension, %i[pointer int32_t pointer], :bool
    attach_function :ngt_set_property_edge_size_for_creation, %i[pointer int16_t pointer], :bool
    attach_function :ngt_set_property_edge_size_for_search, %i[pointer int16_t pointer], :bool
    attach_function :ngt_is_property_object_type_float, %i[int32_t], :bool
    attach_function :ngt_get_property_object_type, %i[pointer pointer], :int32_t
    attach_function :ngt_set_property_object_type_float, %i[pointer pointer], :bool
    attach_function :ngt_set_property_object_type_integer, %i[pointer pointer], :bool
    attach_function :ngt_set_property_distance_type_l1, %i[pointer pointer], :bool
    attach_function :ngt_set_property_distance_type_l2, %i[pointer pointer], :bool
    attach_function :ngt_set_property_distance_type_angle, %i[pointer pointer], :bool
    attach_function :ngt_set_property_distance_type_hamming, %i[pointer pointer], :bool
    attach_function :ngt_set_property_distance_type_jaccard, %i[pointer pointer], :bool
    attach_function :ngt_set_property_distance_type_cosine, %i[pointer pointer], :bool
    attach_function :ngt_set_property_distance_type_normalized_angle, %i[pointer pointer], :bool
    attach_function :ngt_set_property_distance_type_normalized_cosine, %i[pointer pointer], :bool
    attach_function :ngt_insert_index, %i[pointer pointer uint32 pointer], :int
    attach_function :ngt_insert_index_as_float, %i[pointer pointer uint32 pointer], :int
    attach_function :ngt_create_empty_results, %i[pointer], :pointer
    attach_function :ngt_search_index, %i[pointer pointer int32 size_t float float pointer pointer], :bool
    attach_function :ngt_get_result_size, %i[pointer pointer], :uint32
    attach_function :ngt_get_result, %i[pointer uint32 pointer], ObjectDistance.by_value
    attach_function :ngt_batch_insert_index, %i[pointer pointer uint32 pointer pointer], :bool
    attach_function :ngt_create_index, %i[pointer uint32 pointer], :bool
    attach_function :ngt_remove_index, %i[pointer int pointer], :bool
    attach_function :ngt_get_object_space, %i[pointer pointer], :pointer
    attach_function :ngt_get_object_as_float, %i[pointer int pointer], :pointer
    attach_function :ngt_get_object_as_integer, %i[pointer int pointer], :pointer
    attach_function :ngt_destroy_results, %i[pointer], :void
    attach_function :ngt_destroy_property, %i[pointer], :void
    attach_function :ngt_close_index, %i[pointer], :void
    attach_function :ngt_get_property_edge_size_for_creation, %i[pointer pointer], :int16
    attach_function :ngt_get_property_edge_size_for_search, %i[pointer pointer], :int16
    attach_function :ngt_get_property_distance_type, %i[pointer pointer], :int32
    attach_function :ngt_create_error_object, %i[], :pointer
    attach_function :ngt_get_error_string, %i[pointer], :string
    attach_function :ngt_destroy_error_object, %i[pointer], :void

    begin
      attach_function :ngt_create_optimizer, %i[bool pointer], :pointer
      attach_function :ngt_optimizer_adjust_search_coefficients, %i[pointer string pointer], :bool
      attach_function :ngt_optimizer_execute, %i[pointer string string pointer], :bool
      attach_function :ngt_optimizer_set, %i[pointer int int int float float float float double double pointer], :bool
      attach_function :ngt_destroy_optimizer, %i[pointer], :void
    rescue ::FFI::NotFoundError
      # only available in 1.8.1+
    end
  end
end

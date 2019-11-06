module Ngt
  module FFI
    extend Fiddle::Importer

    libs = Ngt.ffi_lib.dup
    begin
      dlload libs.shift
    rescue Fiddle::DLError => e
      retry if libs.any?
      raise e if ENV["NGT_DEBUG"]
      raise LoadError, "Could not find NGT"
    end

    # https://github.com/yahoojapan/NGT/blob/master/lib/NGT/Capi.h
    # keep same order

    typealias "bool", "int"
    typealias "int16_t", "short"
    typealias "int32_t", "int"
    typealias "uint32_t", "unsigned int"

    typealias "ObjectID", "unsigned int"
    typealias "NGTIndex", "void*"
    typealias "NGTProperty", "void*"
    typealias "NGTObjectSpace", "void*"
    typealias "NGTObjectDistances", "void*"
    typealias "NGTError", "void*"
    typealias "NGTOptimizer", "void*"

    NGTObjectDistance = struct [
      "ObjectID id",
      "float distance",
    ]

    extern "NGTIndex ngt_open_index(const char *, NGTError)"
    extern "NGTIndex ngt_create_graph_and_tree(const char *, NGTProperty, NGTError)"
    extern "NGTProperty ngt_create_property(NGTError)"
    extern "bool ngt_save_index(NGTIndex, const char *, NGTError)" # removed const
    extern "bool ngt_get_property(NGTIndex, NGTProperty, NGTError)" # removed const
    extern "int32_t ngt_get_property_dimension(NGTProperty, NGTError)"
    extern "bool ngt_set_property_dimension(NGTProperty, int32_t, NGTError)"
    extern "bool ngt_set_property_edge_size_for_creation(NGTProperty, int16_t, NGTError)"
    extern "bool ngt_set_property_edge_size_for_search(NGTProperty, int16_t, NGTError)"
    extern "int32_t ngt_get_property_object_type(NGTProperty, NGTError)"
    extern "bool ngt_is_property_object_type_float(int32_t)"
    extern "bool ngt_is_property_object_type_integer(int32_t)"
    extern "bool ngt_set_property_object_type_float(NGTProperty, NGTError)"
    extern "bool ngt_set_property_object_type_integer(NGTProperty, NGTError)"
    extern "bool ngt_set_property_distance_type_l1(NGTProperty, NGTError)"
    extern "bool ngt_set_property_distance_type_l2(NGTProperty, NGTError)"
    extern "bool ngt_set_property_distance_type_angle(NGTProperty, NGTError)"
    extern "bool ngt_set_property_distance_type_hamming(NGTProperty, NGTError)"
    extern "bool ngt_set_property_distance_type_jaccard(NGTProperty, NGTError)"
    extern "bool ngt_set_property_distance_type_cosine(NGTProperty, NGTError)"
    extern "bool ngt_set_property_distance_type_normalized_angle(NGTProperty, NGTError)"
    extern "bool ngt_set_property_distance_type_normalized_cosine(NGTProperty, NGTError)"
    extern "NGTObjectDistances ngt_create_empty_results(NGTError)"
    extern "bool ngt_search_index(NGTIndex, double*, int32_t, size_t, float, float, NGTObjectDistances, NGTError)"
    extern "bool ngt_search_index_as_float(NGTIndex, float*, int32_t, size_t, float, float, NGTObjectDistances, NGTError)"
    extern "int32_t ngt_get_size(NGTObjectDistances, NGTError)"
    extern "uint32_t ngt_get_result_size(NGTObjectDistances, NGTError)"
    extern "NGTObjectDistance* ngt_get_result(NGTObjectDistances, uint32_t, NGTError)" # removed const, added *
    extern "ObjectID ngt_insert_index(NGTIndex, double*, uint32_t, NGTError)"
    extern "ObjectID ngt_append_index(NGTIndex, double*, uint32_t, NGTError)"
    extern "ObjectID ngt_insert_index_as_float(NGTIndex, float*, uint32_t, NGTError)"
    extern "ObjectID ngt_append_index_as_float(NGTIndex, float*, uint32_t, NGTError)"
    extern "bool ngt_batch_append_index(NGTIndex, float*, uint32_t, NGTError)"
    extern "bool ngt_batch_insert_index(NGTIndex, float*, uint32_t, uint32_t *, NGTError)"
    extern "bool ngt_create_index(NGTIndex, uint32_t, NGTError)"
    extern "bool ngt_remove_index(NGTIndex, ObjectID, NGTError)"
    extern "NGTObjectSpace ngt_get_object_space(NGTIndex, NGTError)"
    extern "float* ngt_get_object_as_float(NGTObjectSpace, ObjectID, NGTError)"
    extern "uint8_t* ngt_get_object_as_integer(NGTObjectSpace, ObjectID, NGTError)"
    extern "void ngt_destroy_results(NGTObjectDistances)"
    extern "void ngt_destroy_property(NGTProperty)"
    extern "void ngt_close_index(NGTIndex)"
    extern "int16_t ngt_get_property_edge_size_for_creation(NGTProperty, NGTError)"
    extern "int16_t ngt_get_property_edge_size_for_search(NGTProperty, NGTError)"
    extern "int32_t ngt_get_property_distance_type(NGTProperty, NGTError)"
    extern "NGTError ngt_create_error_object()"
    extern "const char *ngt_get_error_string(NGTError)" # removed const
    extern "void ngt_clear_error_string(NGTError)"
    extern "void ngt_destroy_error_object(NGTError)"

    begin
      extern "NGTOptimizer ngt_create_optimizer(bool logDisabled, NGTError)"
      extern "bool ngt_optimizer_adjust_search_coefficients(NGTOptimizer, const char *, NGTError)"
      extern "bool ngt_optimizer_execute(NGTOptimizer, const char *, const char *, NGTError)"
      extern "bool ngt_optimizer_set(NGTOptimizer optimizer, int outgoing, int incoming, int nofqs, float baseAccuracyFrom, float baseAccuracyTo, float rateAccuracyFrom, float rateAccuracyTo, double qte, double m, NGTError error)"
      extern "void ngt_destroy_optimizer(NGTOptimizer)"
    rescue Fiddle::DLError
      # only available in 1.8.1+
    end
  end
end

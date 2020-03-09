module Ngt
  class Index
    include Utils

    attr_reader :path

    def initialize(index, path)
      @index = index
      @path = path

      @error = FFI.ngt_create_error_object
      @property = ffi(:ngt_create_property)
      ffi(:ngt_get_property, @index, @property)

      ObjectSpace.define_finalizer(self, self.class.finalize(@error, @index, @property))
    end

    def dimensions
      @dimensions ||= ffi(:ngt_get_property_dimension, @property)
    end

    def distance_type
      @distance_type ||= ffi(:ngt_get_property_distance_type, @property)
    end

    def edge_size_for_creation
      @edge_size_for_creation ||= ffi(:ngt_get_property_edge_size_for_creation, @property)
    end

    def edge_size_for_search
      @edge_size_for_search ||= ffi(:ngt_get_property_edge_size_for_search, @property)
    end

    def object_type
      @object_type ||= begin
        object_type = ffi(:ngt_get_property_object_type, @property)
        FFI.ngt_is_property_object_type_float(object_type) ? :float : :integer
      end
    end

    def insert(object)
      ffi(:ngt_insert_index, @index, c_object(object.to_a), dimensions)
    end

    def batch_insert(objects, num_threads: 8)
      if narray?(objects)
        objects = objects.cast_to(Numo::SFloat) unless objects.is_a?(Numo::SFloat)
        count = objects.shape[0]
        obj = ::FFI::MemoryPointer.new(:char, objects.byte_size)
        obj.write_bytes(objects.to_binary)
      else
        objects = objects.to_a
        count = objects.size
        flat_objects = objects.flatten
        obj = ::FFI::MemoryPointer.new(:float, flat_objects.size)
        obj.write_array_of_float(flat_objects)
      end

      ids = ::FFI::MemoryPointer.new(:uint32, count)
      ffi(:ngt_batch_insert_index, @index, obj, count, ids)

      build_index(num_threads: num_threads)

      ids.read_array_of_uint32(count)
    end

    def build_index(num_threads: 8)
      ffi(:ngt_create_index, @index, num_threads)
    end

    def object(id)
      if object_type == :float
        res = ffi(:ngt_get_object_as_float, @object_space, id)
        res.read_array_of_float(dimensions)
      else
        res = ffi(:ngt_get_object_as_integer, @object_space, id)
        res.read_array_of_uint8(dimensions)
      end
    end

    def remove(id)
      ffi(:ngt_remove_index, @index, id)
    end

    def search(query, size: 20, epsilon: 0.1, radius: nil)
      radius ||= -1.0
      results = ffi(:ngt_create_empty_results)
      ffi(:ngt_search_index, @index, c_object(query.to_a), dimensions, size, epsilon, radius, results)
      result_size = ffi(:ngt_get_result_size, results)
      ret = []
      result_size.times do |i|
        res = ffi(:ngt_get_result, results, i)
        ret << {
          id: res[:id],
          distance: res[:distance]
        }
      end
      ret
    ensure
      FFI.ngt_destroy_results(results) if results
    end

    def save(path2 = nil, path: nil)
      warn "[ngt] Passing path as an option is deprecated - use an argument instead" if path
      @path = path || path2 || @path || Dir.mktmpdir
      ffi(:ngt_save_index, @index, @path)
    end

    def close
      FFI.ngt_close_index(@index)
    end

    def self.new(dimensions, path: nil, edge_size_for_creation: 10,
        edge_size_for_search: 40, object_type: :float, distance_type: :l2)

      error = FFI.ngt_create_error_object

      # TODO remove in 0.4.0
      if !dimensions.is_a?(Integer) && !path
        warn "[ngt] Passing a path to new is deprecated - use load instead"
        path = dimensions
        dimensions = nil
      end

      if path && dimensions.nil?
        index = ffi(:ngt_open_index, path, error)
      else
        property = ffi(:ngt_create_property, error)
        ffi(:ngt_set_property_dimension, property, dimensions, error)
        ffi(:ngt_set_property_edge_size_for_creation, property, edge_size_for_creation, error)
        ffi(:ngt_set_property_edge_size_for_search, property, edge_size_for_search, error)

        case object_type.to_s.downcase
        when "float"
          ffi(:ngt_set_property_object_type_float, property, error)
        when "integer"
          ffi(:ngt_set_property_object_type_integer, property, error)
        else
          raise ArgumentError, "Unknown object type: #{object_type}"
        end

        case distance_type.to_s.downcase
        when "l1"
          ffi(:ngt_set_property_distance_type_l1, property, error)
        when "l2"
          ffi(:ngt_set_property_distance_type_l2, property, error)
        when "angle"
          ffi(:ngt_set_property_distance_type_angle, property, error)
        when "hamming"
          ffi(:ngt_set_property_distance_type_hamming, property, error)
        when "jaccard"
          ffi(:ngt_set_property_distance_type_jaccard, property, error)
        when "cosine"
          ffi(:ngt_set_property_distance_type_cosine, property, error)
        when "normalized_angle"
          ffi(:ngt_set_property_distance_type_normalized_angle, property, error)
        when "normalized_cosine"
          ffi(:ngt_set_property_distance_type_normalized_cosine, property, error)
        else
          raise ArgumentError, "Unknown distance type: #{distance_type}"
        end

        index =
          if path
            ffi(:ngt_create_graph_and_tree, path, property, error)
          else
            ffi(:ngt_create_graph_and_tree_in_memory, property, error)
          end
      end

      super(index, path)
    ensure
      FFI.ngt_destroy_error_object(error) if error
      FFI.ngt_destroy_property(property) if property
    end

    def self.load(path)
      new(nil, path: path)
    end

    def self.create(path, dimensions, **options)
      warn "[ngt] create is deprecated - use new instead"
      new(dimensions, path: path, **options)
    end

    # private
    def self.ffi(*args)
      Utils.ffi(*args)
    end

    def self.finalize(error, index, property)
      # must use proc instead of stabby lambda
      proc do
        FFI.ngt_destroy_error_object(error)
        FFI.ngt_close_index(index)
        FFI.ngt_destroy_property(property)
      end
    end

    private

    def narray?(data)
      defined?(Numo::NArray) && data.is_a?(Numo::NArray)
    end

    def c_object(object)
      c_object = ::FFI::MemoryPointer.new(:double, object.size)
      c_object.write_array_of_double(object)
      c_object
    end
  end
end

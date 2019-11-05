module Ngt
  class Index
    def initialize(path)
      @path = path
      @error = FFI.ngt_create_error_object
      @index = ffi(:ngt_open_index, path)

      property = ffi(:ngt_create_property)
      ffi(:ngt_get_property, @index, property)

      @dimension = ffi(:ngt_get_property_dimension, property)

      object_type = ffi(:ngt_get_property_object_type, property)
      @float = FFI.ngt_is_property_object_type_float(object_type)

      @object_space = ffi(:ngt_get_object_space, @index)

      ObjectSpace.define_finalizer(self, self.class.finalize(@error))
    end

    def insert(object)
      ffi(:ngt_insert_index, @index, c_object(object.to_a), @dimension)
    end

    # TODO make more performant for Numo
    def batch_insert(objects, num_threads: 8)
      objects = objects.to_a
      flat_objects = objects.flatten
      obj = Fiddle::Pointer[flat_objects.pack("e*")]

      ids = Fiddle::Pointer.malloc(Fiddle::SIZEOF_INT * objects.size)
      ffi(:ngt_batch_insert_index, @index, obj, objects.size, ids)

      build_index(num_threads: num_threads)

      ids.to_str(ids.size).unpack("I*")
    end

    def build_index(num_threads: 8)
      ffi(:ngt_create_index, @index, num_threads)
    end

    def object(id)
      if float?
        res = ffi(:ngt_get_object_as_float, @object_space, id)
        res.read_array_of_float(@dimension)
      else
        res = ffi(:ngt_get_object_as_integer, @object_space, id)
        res.read_array_of_uint8(@dimension)
      end
    end

    def remove(id)
      ffi(:ngt_remove_index, @index, id)
    end

    def search(query, size: 20, epsilon: 0.1, radius: nil)
      radius ||= -1.0
      results = ffi(:ngt_create_empty_results)
      ffi(:ngt_search_index, @index, c_object(query.to_a), @dimension, size, epsilon, radius, results)
      result_size = ffi(:ngt_get_result_size, results)
      ret = []
      result_size.times do |i|
        res = FFI::NGTObjectDistance.new(ffi(:ngt_get_result, results, i).ref)
        ret << {
          id: res.id,
          distance: res.distance
        }
      end
      ret
    end

    def save(path: nil)
      path ||= @path
      ffi(:ngt_save_index, @index, path)
    end

    def close
      FFI.ngt_close_index(@index)
    end

    def self.create(path, dimension, edge_size_for_creation: 10,
        edge_size_for_search: 40, object_type: "Float", distance_type: "L2")

      error = FFI.ngt_create_error_object
      property = ffi(:ngt_create_property, error)
      ffi(:ngt_set_property_dimension, property, dimension, error)
      ffi(:ngt_set_property_edge_size_for_creation, property, edge_size_for_creation, error)
      ffi(:ngt_set_property_edge_size_for_search, property, edge_size_for_search, error)

      case object_type.to_s
      when "Float", "float"
        ffi(:ngt_set_property_object_type_float, property, error)
      when "Integer", "integer"
        ffi(:ngt_set_property_object_type_integer, property, error)
      else
        raise ArgumentError, "Unknown object type: #{object_type}"
      end

      case distance_type.to_s
      when "L1"
        ffi(:ngt_set_property_distance_type_l1, property, error)
      when "L2"
        ffi(:ngt_set_property_distance_type_l2, property, error)
      when "Angle"
        ffi(:ngt_set_property_distance_type_angle, property, error)
      when "Hamming"
        ffi(:ngt_set_property_distance_type_hamming, property, error)
      when "Jaccard"
        ffi(:ngt_set_property_distance_type_jaccard, property, error)
      when "Cosine"
        ffi(:ngt_set_property_distance_type_cosine, property, error)
      else
        raise ArgumentError, "Unknown distance type: #{distance_type}"
      end

      index = ffi(:ngt_create_graph_and_tree, path, property, error)
      FFI.ngt_close_index(index)
      index = nil

      Index.new(path)
    ensure
      FFI.ngt_destroy_error_object(error) if error
      FFI.ngt_destroy_property(property) if property
      FFI.ngt_close_index(index) if index
    end

    # private
    def self.ffi(method, *args)
      res = FFI.send(method, *args)
      message = FFI.ngt_get_error_string(args.last)
      raise Error, message unless message.to_s.empty?
      res
    end

    def self.finalize(error)
      # must use proc instead of stabby lambda
      proc do
        # TODO clean-up more objects
        FFI.ngt_destroy_error_object(error)
      end
    end

    private

    def ffi(*args)
      self.class.ffi(*args, @error)
    end

    def float?
      @float
    end

    def c_object(object)
      Fiddle::Pointer[object.pack("E*")]
    end
  end
end

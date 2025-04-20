require_relative "test_helper"

class IndexTest < Minitest::Test
  def test_works
    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]

    index = Ngt::Index.new(4)
    assert_equal :l2, index.distance_type
    assert_equal 10, index.edge_size_for_creation
    assert_equal 40, index.edge_size_for_search
    assert_equal :float, index.object_type

    assert_equal [1, 2, 3], index.batch_insert(objects)
    path = Dir.mktmpdir
    assert_equal true, index.save(path)

    query = objects[0]
    result = index.search(query, size: 3)

    assert_equal 3, result.size
    assert_equal [1, 3, 2], result.map { |r| r[:id] }
    assert_equal 0, result[0][:distance]
    assert_in_delta 1.732050776481628, result[1][:distance]
    assert_in_delta 7.549834251403809, result[2][:distance]

    index = Ngt::Index.load(path)
    assert_equal 4, index.dimensions
    result = index.search(query, size: 3)
    assert_equal [1, 3, 2], result.map { |r| r[:id] }
  end

  def test_zero_vector
    objects = [
      [1, 1, 2, 1],
      [0, 0, 0, 0],
      [1, 2, 1, 2]
    ]

    index = Ngt::Index.new(4, distance_type: :cosine)
    index.batch_insert(objects)
    result = index.search(objects[0], size: 3)
    # TODO decide how to handle
    assert_equal [1], result.map { |r| r[:id] }
  end

  def test_nan
    objects = [
      [1, 1, 2, 1],
      [Float::NAN, 1, 2, 3],
      [1, 2, 1, 2]
    ]

    index = Ngt::Index.new(4, distance_type: :cosine)
    index.batch_insert(objects)
    result = index.search(objects[0], size: 3)
    # TODO decide how to handle
    assert_equal [1], result.map { |r| r[:id] }
  end

  def test_infinite
    objects = [
      [1, 1, 2, 1],
      [Float::INFINITY, 1, 2, 3],
      [1, 2, 1, 2]
    ]

    index = Ngt::Index.new(4, distance_type: :cosine)
    index.batch_insert(objects)
    result = index.search(objects[0], size: 3)
    # TODO decide how to handle
    assert_equal [1], result.map { |r| r[:id] }
  end

  def test_numo
    skip if ["jruby", "truffleruby"].include?(RUBY_ENGINE)

    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]
    objects = Numo::DFloat.cast(objects)

    index = Ngt::Index.new(4)
    assert_equal [1, 2, 3], index.batch_insert(objects)
    assert_equal true, index.save

    query = objects[0, true]
    result = index.search(query, size: 3)

    assert_equal 3, result.size
    assert_equal [1, 3, 2], result.map { |r| r[:id] }
    assert_equal 0, result[0][:distance]
    assert_in_delta 1.732050776481628, result[1][:distance]
    assert_in_delta 7.549834251403809, result[2][:distance]
  end

  def test_remove
    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]

    index = Ngt::Index.new(4)
    assert_equal [1, 2, 3], index.batch_insert(objects)

    assert_equal true, index.remove(3)
    # TODO remove assert_raises in 0.5.0
    assert_raises do
      assert_equal false, index.remove(3)
    end
    assert_raises do
      assert_equal false, index.remove(4)
    end

    result = index.search(objects[0])
    assert_equal 2, result.size
  end

  def test_object_type_float16
    object = [1.5, 2.5, 3.5]
    index = Ngt::Index.new(3, object_type: :float16)
    assert_equal :float16, index.object_type
    assert_equal 1, index.insert(object)
    assert_equal true, index.build_index
    error = assert_raises(Ngt::Error) do
      index.object(1)
    end
    assert_equal "Method not supported for this object type", error.message
  end

  def test_object_type_integer
    object = [1, 2, 3]
    index = Ngt::Index.new(3, object_type: :integer)
    assert_equal :integer, index.object_type
    assert_equal 1, index.insert(object)
    assert_equal true, index.build_index
    assert_equal object, index.object(1)
  end

  def test_empty
    index = Ngt::Index.new(3)
    assert_empty index.batch_insert([])
  end

  def test_ffi_error
    error = assert_raises(Ngt::Error) do
      Ngt::Index.new(0, path: Dir.mktmpdir)
    end
    assert_match "Dimension is not specified", error.message
  end

  def test_bad_object_type
    error = assert_raises(ArgumentError) do
      Ngt::Index.new(3, object_type: "bad")
    end
    assert_equal "Unknown object type: bad", error.message
  end

  def test_bad_distance_type
    error = assert_raises(ArgumentError) do
      Ngt::Index.new(3, distance_type: "bad")
    end
    assert_equal "Unknown distance type: bad", error.message
  end

  def test_insert_bad_dimensions
    error = assert_raises(ArgumentError) do
      Ngt::Index.new(3).insert([1, 2])
    end
    assert_equal "Bad dimensions", error.message
  end

  def test_batch_insert_bad_dimensions
    error = assert_raises(ArgumentError) do
      Ngt::Index.new(3).batch_insert([[1, 2]])
    end
    assert_equal "Bad dimensions", error.message
  end

  def test_search_bad_dimensions
    index = Ngt::Index.new(3)
    index.insert([1, 2, 3])
    error = assert_raises(ArgumentError) do
      index.search([1, 2])
    end
    assert_equal "Bad dimensions", error.message
  end

  def test_copy
    index = Ngt::Index.new(4)
    index.dup
    index.clone
  end
end

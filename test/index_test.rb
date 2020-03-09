require_relative "test_helper"

class IndexTest < Minitest::Test
  def test_deprecated
    dim = 4
    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]

    path = Dir.mktmpdir
    index = Ngt::Index.create(path, dim)
    assert_equal [1, 2, 3], index.batch_insert(objects)
    index.save

    query = objects[0]
    result = index.search(query, size: 3)

    assert_equal 3, result.size
    assert_equal [1, 3, 2], result.map { |r| r[:id] }
    assert_equal 0, result[0][:distance]
    assert_in_delta 1.732050776481628, result[1][:distance]
    assert_in_delta 7.549834251403809, result[2][:distance]

    index = Ngt::Index.new(path)
    result = index.search(query, size: 3)
    assert_equal [1, 3, 2], result.map { |r| r[:id] }
  end

  def test_works
    dim = 4
    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]

    index = Ngt::Index.new(dim)
    assert_equal :l2, index.distance_type
    assert_equal 10, index.edge_size_for_creation
    assert_equal 40, index.edge_size_for_search
    assert_equal :float, index.object_type

    assert_equal [1, 2, 3], index.batch_insert(objects)
    path = Dir.mktmpdir
    index.save(path)

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

  def test_numo
    dim = 4
    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]
    objects = Numo::DFloat.cast(objects)

    index = Ngt::Index.new(dim)
    assert_equal [1, 2, 3], index.batch_insert(objects)
    index.save

    query = objects[0, true]
    result = index.search(query, size: 3)

    assert_equal 3, result.size
    assert_equal [1, 3, 2], result.map { |r| r[:id] }
    assert_equal 0, result[0][:distance]
    assert_in_delta 1.732050776481628, result[1][:distance]
    assert_in_delta 7.549834251403809, result[2][:distance]
  end

  def test_ffi_error
    error = assert_raises(Ngt::Error) do
      Ngt::Index.new(0, path: Dir.mktmpdir)
    end
    assert_match "Dimension is not specified", error.message
  end

  def test_bad_object_type
    error = assert_raises(ArgumentError) do
      Ngt::Index.new(10, object_type: "bad")
    end
    assert_equal "Unknown object type: bad", error.message
  end

  def test_bad_distance_type
    error = assert_raises(ArgumentError) do
      Ngt::Index.new(10, distance_type: "bad")
    end
    assert_equal "Unknown distance type: bad", error.message
  end
end

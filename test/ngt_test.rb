require_relative "test_helper"

class NgtTest < Minitest::Test
  def test_works
    dim = 4
    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]

    index = Ngt::Index.create(Dir.mktmpdir, dim)
    assert_equal [1, 2, 3], index.batch_insert(objects)
    index.save

    query = objects[0]
    result = index.search(query, size: 3)

    assert_equal 3, result.size
    assert_equal [1, 3, 2], result.map { |r| r[:id] }
    assert_equal 0, result[0][:distance]
    assert_in_delta 1.732050776481628, result[1][:distance]
    assert_in_delta 7.549834251403809, result[2][:distance]
  end

  def test_optimizer
    dim = 4
    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]

    path = Dir.mktmpdir
    index = Ngt::Index.create(path, dim)
    index.batch_insert(objects)
    index.save

    optimizer = Ngt::Optimizer.new(queries: 1)
    optimizer.adjust_search_coefficients(path)
    optimizer.execute(path, Dir.mktmpdir)
  end

  def test_numo
    dim = 4
    objects = [
      [1, 1, 2, 1],
      [5, 4, 6, 5],
      [1, 2, 1, 2]
    ]
    objects = Numo::DFloat.cast(objects)

    index = Ngt::Index.create(Dir.mktmpdir, dim)
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
    assert_raises Ngt::Error do
      Ngt::Index.create(Dir.mktmpdir, 0)
    end
  end

  def test_bad_object_type
    error = assert_raises ArgumentError do
      Ngt::Index.create(Dir.mktmpdir, 10, object_type: "bad")
    end
    assert_equal "Unknown object type: bad", error.message
  end

  def test_bad_distance_type
    error = assert_raises ArgumentError do
      Ngt::Index.create(Dir.mktmpdir, 10, distance_type: "bad")
    end
    assert_equal "Unknown distance type: bad", error.message
  end
end

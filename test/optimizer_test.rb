require_relative "test_helper"

class OptimizerTest < Minitest::Test
  def test_works
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
end

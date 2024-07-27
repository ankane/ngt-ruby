# NGT Ruby

[NGT](https://github.com/yahoojapan/NGT) - high-speed approximate nearest neighbors - for Ruby

[![Build Status](https://github.com/ankane/ngt-ruby/actions/workflows/build.yml/badge.svg)](https://github.com/ankane/ngt-ruby/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "ngt"
```

On Mac, also install OpenMP:

```sh
brew install libomp
```

NGT is not available for Windows

## Getting Started

Prep your data

```ruby
objects = [
  [1, 1, 2, 1],
  [5, 4, 6, 5],
  [1, 2, 1, 2]
]
```

Create an index

```ruby
index = Ngt::Index.new(dimensions)
```

Insert objects

```ruby
index.batch_insert(objects)
```

Search the index

```ruby
index.search(query, size: 3)
```

Save the index

```ruby
index.save(path)
```

Load an index

```ruby
index = Ngt::Index.load(path)
```

Get an object by id

```ruby
index.object(id)
```

Insert a single object

```ruby
index.insert(object)
```

Remove an object by id

```ruby
index.remove(id)
```

Build the index

```ruby
index.build_index
```

Optimize the index

```ruby
optimizer = Ngt::Optimizer.new(outgoing: 10, incoming: 120)
optimizer.adjust_search_coefficients(index)
optimizer.execute(index, new_path)
```

## Full Example

```ruby
dim = 10
objects = []
100.times do |i|
  objects << dim.times.map { rand(100) }
end

index = Ngt::Index.new(dim)
index.batch_insert(objects)

query = objects[0]
result = index.search(query, size: 3)

result.each do |res|
  puts "#{res[:id]}, #{res[:distance]}"
  p index.object(res[:id])
end
```

## Index Options

Defaults shown below

```ruby
Ngt::Index.new(dimensions,
  edge_size_for_creation: 10,
  edge_size_for_search: 40,
  object_type: :float, # :float, :integer
  distance_type: :l2,  # :l1, :l2, :hamming, :angle, :cosine, :normalized_angle, :normalized_cosine, :jaccard
  path: nil
)
```

## Optimizer Options

Defaults shown below

```ruby
Ngt::Optimizer.new(
  outgoing: 10,
  incoming: 120,
  queries: 100,
  low_accuracy_from: 0.3,
  low_accuracy_to: 0.5,
  high_accuracy_from: 0.8,
  high_accuracy_to: 0.9,
  gt_epsilon: 0.1,
  merge: 0.2
)
```

## Data

Data can be an array of arrays

```ruby
[[1, 2, 3], [4, 5, 6]]
```

Or a Numo array

```ruby
Numo::NArray.cast([[1, 2, 3], [4, 5, 6]])
```

## Resources

- [ANN Benchmarks](https://github.com/erikbern/ann-benchmarks)

## Credits

This library is modeled after NGT’s [Python API](https://github.com/yahoojapan/NGT/blob/master/python/README-ngtpy.md).

## History

View the [changelog](https://github.com/ankane/ngt-ruby/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/ngt-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/ngt-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/ngt-ruby.git
cd ngt-ruby
bundle install
bundle exec rake vendor:all
bundle exec rake test
```

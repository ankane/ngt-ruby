# NGT

[NGT](https://github.com/yahoojapan/NGT) - high-speed approximate nearest neighbors - for Ruby

[![Build Status](https://travis-ci.org/ankane/ngt.svg?branch=master)](https://travis-ci.org/ankane/ngt)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'ngt'
```

NGT is not available for Windows yet

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
optimizer.execute(path, new_path)
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
  distance_type: :l2,  # :l1, :l2, :hamming, :angle, :cosine, or :jaccard
  path: nil
)
```

## Data

Data can be an array of arrays

```ruby
[[1, 2, 3], [4, 5, 6]]
```

Or a Numo NArray

```ruby
Numo::DFloat.new(3, 2).seq
```

## Resources

- [ANN Benchmarks](https://github.com/erikbern/ann-benchmarks)

## Credits

This library is modeled after NGT’s [Python API](https://github.com/yahoojapan/NGT/blob/master/python/README-ngtpy.md).

## History

View the [changelog](https://github.com/ankane/ngt/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/ngt/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/ngt/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/ngt.git
cd ngt
bundle install
bundle exec rake vendor:all
bundle exec rake test
```

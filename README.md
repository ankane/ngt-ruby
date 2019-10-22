# NGT

[NGT](https://github.com/yahoojapan/NGT) - high-speed approximate nearest neighbors - for Ruby

## Installation

First, [install NGT](https://github.com/yahoojapan/NGT/blob/master/README.md#Installation).

Add this line to your application’s Gemfile:

```ruby
gem 'ngt'
```

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
index = Ngt::Index.create(path, dimensions)
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
index.save
```

Load an index

```ruby
Ngt::Index.new(path)
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

## Full Example

```ruby
dim = 10
objects = []
100.times do |i|
  objects << dim.times.map { rand(100) }
end

index = Ngt::Index.create("tmp", dim)
index.batch_insert(objects)
index.save

query = objects[0]
result = index.search(query, size: 3)

result.each do |res|
  puts "#{res[:id]}, #{res[:distance]}"
  object = index.object(res[:id])
  p object
end
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

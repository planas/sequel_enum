# Sequel_enum

A Sequel plugin that provides enum-like functionality to your models.

## Installation

Add this line to your application's Gemfile:

    gem 'sequel_enum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_enum

## Usage

```ruby
class Item < Sequel::Model
  plugin :enum
  enum :condition, [:mint, :good, :poor]
end

item = Item.new
item.condition = :mint

print item.condition #> :mint
print item.mint? #> true
print item.good? #> false

item.update(:condition => :good)

print item.good? #> true
print item.condition? :good #> true
```

```#enum``` accepts a hash like ```{ :alias => value }``` as well:

```ruby
class Item < Sequel::Model
  plugin :enum
  enum :condition, { mint: 10, good: 11, poor: 15 }
end

item = Item.create(:condition => :mint)

print item[:condition] #> 10
```

You can set the raw value through the []= accessor:

```ruby
item[:condition] = 15
print item.condition #> :poor
```
You can set the raw value directly

```ruby
item.condition = 15
print item.condition #> :poor
```
## Contributing

1. Fork it ( http://github.com/planas/sequel_enum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

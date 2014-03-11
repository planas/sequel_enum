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

  item.condition #> :mint
  item.mint? #> true
  item.good? #> false
```ruby

```#enum``` accepts a hash like ```{ index => value }``` as well:

```ruby
  class Item < Sequel::Model
    plugin :enum
    enum :condition, [10 => :mint, 11 => :good, 15 => :poor]
  end

  item = Item.new
  item.condition = :mint

  item[:condition] #> 10
```ruby


## Contributing

1. Fork it ( http://github.com/<my-github-username>/sequel_enum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

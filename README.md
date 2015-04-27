# tinydi

> Really really really tiny Dependency Injection lib

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tinydi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tinydi

## Usage

```ruby

# Consider this utility class
# it could be a service object or an API client
class SomeWidget
  def initialize(factor)
    @factor = factor
  end
  def magic!
   @factor * "✨"
 end
end

# and this is your class which has logic and
# needs to use other classes
# We can inject SomeWidget so it is available for instantiation
# for the instance of our class

class FooBar
  include TinyDI.expose(SomeWidget => :build_widget)
end

# now you can do something like this:

foo = FooBar.new
foo.build_widget(2).magic! #=> ✨

```

### Why this is useful?

Testing is one use case for example - you can mock out your class' depeendencies
and test just the logic not worrying about what these dependencies are up to
just as long they have consisten interface.

### This is not real DI!

Yup

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tinydi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


(c) Łukasz Korecki, licensed under LGPL

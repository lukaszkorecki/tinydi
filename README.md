# TinyDI

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
class TwitterClient
  def initialize(username)
    @username = username
  end

  def tweet!(status)
    # call twitter API and post a tweet
 end
end

# and this is your class which has logic and
# needs to use other classes
# We can inject SomeWidget so it is available for instantiation
# for the instance of our class

class Notifier
  include TinyDI[
            TwitterClient => :twitter_client
          ]

end

# now you can do something like this:

notifier = Notifier.new
notifier.twitter_client('@lukaszkorecki').tweet! 'Bananas!'

# Now in our test we can do sometging like this


```ruby

class FakeTwitterClient < TwitterClient
  def tweet!(status)
    status
  end
end

test 'notifies via twitter' do
  notif = Notifier.new
  notif.twitter_client_class = FakeTwitterClient
  assert_equal 'tweet!', notif.twitter_client('@lukaszkorecki').tweet! 'tweet!'
end
```

### Why this is useful?

Testing is one use case for example - you can mock out your class' depeendencies
and test just the logic not worrying about what these dependencies are up to
just as long they have consisten interface.

You can also dynamically inject dependencies for your instance depending on
conditions, for example setting different type of a database adapter
depending on the settings.

### This is not real DI!

Yup. Maybe. It's ok for me.

### Is it slow?

Only a bit slower, (see `benchmark.rb`)

```
Calculating -------------------------------------
              tinydi    10.000  i/100ms
               class    12.000  i/100ms
-------------------------------------------------
              tinydi    103.866  (± 6.7%) i/s -    520.000
               class    136.831  (± 7.3%) i/s -    684.000

Comparison:
               class:      136.8 i/s
              tinydi:      103.9 i/s - 1.32x slower

```

## Development

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release` to create a git
tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tinydi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


(c) Łukasz Korecki, licensed under LGPL

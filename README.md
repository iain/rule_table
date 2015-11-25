# RuleTable

Based on [RubyTapas episode 358](http://www.rubytapas.com/episodes/358-Rule-Table),
this is a simple rule table, but with a more fancy API. In fact, I'm using all
of Ruby's meta programming tricks to get here. That might not be your cup of tea
and that's okay.

In short, RuleTable allows you to flatten the state space of a problem.
Instead of branching, and branching, and branching again, we can see all the
criteria for a given target in one place.

Essentially, it turns a big nested set of rules into a flat list of rules.

This is a tiny gem, made in one evening.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rule_table'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rule_table

## Usage

To get the full context of this example, see the RubyTapas episode.

First up, let's define the matchers. These allow you to do define checks that
can be used later on. A matcher has a name and block. The name is used to
reference it later on. The block defines how the matcher should be applied. We
use `instance_exec` to put you inside the object you're matching against.

``` ruby
RuleTable.matcher :os do |pattern|
  pattern === os
end

RuleTable.matcher :width do |pattern|
  pattern === resolution.width
end

RuleTable.matcher :height do |pattern|
  pattern === resolution.height
end

RuleTable.matcher :misc do |pattern|
  pattern === user_agent_misc
end
```

Next up is defining the rules. Rules are order dependent. The first rule for
which everything matches, is the one that is returned.

``` ruby
TABLE = RuleTable.new do

  rule :ios_hi, match(:os,     /ios/i),
                match(:width,  1024..2732),
                match(:height, 768..2048)

  rule :ios_lo, match(:os,     /ios/i),
                match(:width,  0...1024),
                match(:height, 0...768)

  rule :ereader, match(:os,    /android/i),
                 match(:misc,  /inky/i)

  # more rules omitted

  rule :unknown

end
```

Finally, we can find the rule:

``` ruby
device = OpenStruct.new(
  os: "Android",
  resolution: OpenStruct.new(
    width: 1430,
    height: 1080
  ),
  user_agent_misc: "(Inky)",
)

TABLE.match(device) # => :ereader
```

Finally, there is also a way to debug why a certain target was found. Simply
replace the message send `match` with `match_with_trace`.

```
target, trace = TABLE.match_with_trace(device)
target # => :ereader
trace # =>
# [
#   { target: :ios_hi,  matched: [] },
#   { target: :ios_lo,  matched: [] },
#   { target: :ereader, matched: [:os, :misc] }
# ]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iain/rule_table.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


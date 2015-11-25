require "rule_table/version"

module RuleTable

  def self.matcher(name, &block)
    matchers[name] = block
  end

  def self.matchers
    @matchers ||= {}
  end

  def self.new(&block)
    Table.new.tap { |table| TableDefiner.new(table, &block) }
  end

  class Table

    def initialize
      @rules = []
    end

    def add_rule_for(target, *matchers)
      @rules << [ target, matchers ]
    end

    def match(object)
      @rules.find { |(_target, matchers)|
        matchers.all? { |m| m.matches?(object) }
      }.first
    end

  end

  class TableDefiner

    def initialize(table, &block)
      @table = table
      instance_eval(&block)
    end

    def rule(*args)
      @table.add_rule_for(*args)
    end

    def match(matcher_name, *args)
      ConfiguredMatcher.new(RuleTable.matchers.fetch(matcher_name), *args)
    end

  end

  class ConfiguredMatcher

    def initialize(matcher, *args)
      @matcher = matcher
      @args    = args
    end

    def matches?(object)
      object.instance_exec(*@args, &@matcher)
    end

  end

end

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

    def match_with_trace(object)
      trace = []
      result = @rules.find { |(target, matchers)|
        partial_trace = { target: target, matched: [] }
        matchers.all? { |m|
          m.matches?(object).tap { |match_result|
            partial_trace[:matched] << m.matcher_name if match_result
          }
        }.tap {
          trace << partial_trace
        }
      }.first
      [ result, trace ]
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
      ConfiguredMatcher.new(matcher_name, *args)
    end

  end

  class ConfiguredMatcher

    attr_reader :matcher_name

    def initialize(matcher_name, *args)
      @matcher_name = matcher_name
      @matcher = RuleTable.matchers.fetch(matcher_name)
      @args    = args
    end

    def matches?(object)
      object.instance_exec(*@args, &@matcher)
    end

  end

end

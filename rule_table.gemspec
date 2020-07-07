# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rule_table/version"

Gem::Specification.new do |spec|
  spec.name          = "rule_table"
  spec.version       = RuleTable::VERSION
  spec.authors       = ["iain"]
  spec.email         = ["iain@iain.nl"]

  spec.summary       = "A simple implementation of a rule table with lots of metaprogramming."
  spec.homepage      = "https://github.com/iain/rule_table"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

end

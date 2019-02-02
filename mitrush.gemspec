# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mitrush/version'

Gem::Specification.new do |spec|
  spec.name          = "mitrush"
  spec.version       = Mitrush::VERSION
  spec.authors       = ["Ian McWilliams"]
  spec.email         = ["ian.mcwilliams@f3mmedia.co.uk"]

  spec.summary       = 'Methods I Wish RUby Had'
  spec.description   = 'Some utility methods that would preferably be part of the ruby core functionality'
  spec.homepage      = "https://github.com/f3mmedia/mitrush"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

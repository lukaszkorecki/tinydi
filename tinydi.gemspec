# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tinydi/version'

Gem::Specification.new do |spec|
  spec.name          = 'tinydi'
  spec.version       = TinyDI::VERSION
  spec.authors       = ['Łukasz Korecki']
  spec.email         = ['lukasz@korecki.me']

  spec.summary       = 'Tiny Dependency Injection thing'
  spec.description   = 'Really, really tiny dependency injection, not too much to it'
  spec.homepage      = 'httsp://github.com/nomnom-insights/tinydi'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
end

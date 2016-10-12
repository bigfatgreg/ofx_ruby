# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ofx/version'

Gem::Specification.new do |g|
  g.name          = "ofx_ruby"
  g.version       = OFX::VERSION
  g.authors       = ["rob"]
  g.email         = ["rob.all3n@gmail.com"]
  g.homepage      = "http://graveflex.com"

  g.license       = "MIT"
  g.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|g|features)/}) }
  g.require_paths = ["lib"]

  g.add_development_dependency "bundler", "~> 1.10"
  g.add_development_dependency "rake", "~> 10.0"
  g.add_development_dependency "minitest", "~> 5.9"
  g.add_development_dependency "guard", "~> 2.14.0"
  g.add_development_dependency "dotenv", "~> 2.1.1)"
  
  g.required_ruby_version = ">= 2.3"
  
  g.summary = g.description = %q{A simple, incomplete OFX gem for Ruby.}
end

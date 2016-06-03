# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ofx_ruby/version'

Gem::Specification.new do |g|
  g.name          = "ofx-ruby"
  g.version       = OfxRuby::VERSION
  g.authors       = ["rob"]
  g.email         = ["rob.all3n@gmail.com"]
  g.homepage      = "http://bigfatgreg.net"

  g.license       = "MIT"
  g.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|g|features)/}) }
  g.require_paths = ["lib"]

  g.add_development_dependency "bundler", "~> 1.10"
  g.add_development_dependency "rake", "~> 10.0"
  g.add_development_dependency "minitest", "~> 5.9"
  
  g.required_ruby_version = ">= 2.3"
  
  g.summary = g.description = %q{A simple OFX gem for Ruby.}
end

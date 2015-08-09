# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ror_hack/version'

Gem::Specification.new do |spec|
  spec.name          = "ror_hack"
  spec.version       = RorHack::VERSION
  spec.authors       = ["happyMing"]
  spec.email         = ["happyming9527@gmail.com"]
  spec.summary       = %q{ruby on rails library hack.}
  spec.description   = %q{add some methods to modules of ruby or rails.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end

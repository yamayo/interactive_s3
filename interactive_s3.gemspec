# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interactive_s3/version'

Gem::Specification.new do |spec|
  spec.name          = "interactive_s3"
  spec.version       = InteractiveS3::VERSION
  spec.executables   = ["is3"]
  spec.authors       = ["yamayo"]
  spec.email         = ["noorthaven@gmail.com"]
  spec.summary       = %q{An interactive shell for AWS CLI (aws s3)}
  spec.homepage      = "https://github.com/yamayo/interactive_s3"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end

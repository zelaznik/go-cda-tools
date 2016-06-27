# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "go-cda-tools"
  spec.version       = "0.0.0"
  spec.authors       = ["Andrew Hubley"]
  spec.email         = ["ahubley@mitre.org"]

  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = 'APL 2.0'

  spec.files         = Dir.glob('lib/**/*.rb') + ["Gemfile", "Rakefile"] + Dir.glob('ext/*')
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

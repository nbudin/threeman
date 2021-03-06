# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'threeman/version'

Gem::Specification.new do |spec|
  spec.name          = "threeman"
  spec.version       = Threeman::VERSION
  spec.authors       = ["Nat Budin"]
  spec.email         = ["nbudin@patientslikeme.com"]

  spec.summary       = %q{Runs Procfile commands in tabs}
  spec.description   = %q{An alternative to Foreman, which runs each command in a separate tab}
  spec.homepage      = "https://github.com/patientslikeme/threeman"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "foreman"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rb-scpt"
  spec.add_development_dependency "thor"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sequel_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "sequel_enum"
  spec.version       = SequelEnum::VERSION
  spec.authors       = ["Adrià Planas"]
  spec.email         = ["adriaplanas@liquidcodeworks.com"]
  spec.summary       = %q{A Sequel plugin that provides enum-like functionality to your models}
  spec.homepage      = "https://github.com/planas/sequel_enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sequel"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rspec",   "~> 3.5"
  spec.add_development_dependency "sqlite3", "~> 1.3"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polymer-google-apis/version'

Gem::Specification.new do |spec|
  spec.name          = "polymer-google-apis"
  spec.version       = PolymerGoogleApis::VERSION
  spec.authors       = ["Michael Bevz"]
  spec.email         = ["myb@appfellas.co"]
  spec.description   = %q{Polymer Google APIs web component}
  spec.summary       = %q{Polymer Google APIs}
  spec.homepage      = "https://github.com/AppFellas/polymer-google-apis"
  spec.license       = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  spec.add_runtime_dependency     "polymer-rails", "~>0.1.9"
  
  spec.add_runtime_dependency     "polymer-core-rails", "~>0.1.0"
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

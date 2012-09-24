# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.expand_path('../lib/tilt-jadeite/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bjørge Næss"]
  gem.email         = ["bjoerge@bengler.no"]
  gem.description   = %q{Render Jade templates with help from therubyracer embedded V8 JavaScript interpreter}
  gem.summary       = %q{Also adds Jade support to Sinatra}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tilt-jadeite"
  gem.require_paths = ["lib"]
  gem.version       = Tilt::Jadeite::VERSION

  gem.add_runtime_dependency "tilt"
  gem.add_runtime_dependency "jadeite", '~> 0.0.8'

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "sinatra"
  gem.add_development_dependency "haml"
  gem.add_development_dependency "approvals"

end

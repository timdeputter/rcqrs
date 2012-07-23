# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rcqrs/version"

Gem::Specification.new do |s|
  s.name        = "rcqrs"
  s.version     = Rcqrs::VERSION
  s.authors     = ["Tim de Putter"]
  s.email       = ["tim.de.putter83@googlemail.com"]
  s.homepage    = "no homepage"
  s.summary     = %q{Framework to provide cqrs + eventsourcing functionality in ruby.}
  s.description = %q{Framework to provide cqrs + eventsourcing functionality in ruby.}

  s.rubyforge_project = "rcqrs"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_runtime_dependency "rest-client"

  s.add_development_dependency "rspec"
  s.add_runtime_dependency "uuid"
  
  
end

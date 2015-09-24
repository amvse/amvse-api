# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "amvse/api/version"

Gem::Specification.new do |s|
  s.name        = "amvse-api"
  s.version     = Amvse::API::VERSION
  s.authors     = ["Zane Shannon"]
  s.email       = ["zcs@amvse.com"]
  s.homepage    = "http://docs.amvse.apiary.io/"
  s.license     = 'MIT'
  s.summary     = %q{Ruby Client for the Amvse API}
  s.description = %q{Ruby Client for the Amvse API}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'mime-types', '2.6.2'

  s.add_runtime_dependency 'excon', '~>0.44'
  s.add_runtime_dependency 'multi_json', '~>1.8'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
end
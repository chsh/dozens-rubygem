# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dozens/version"

Gem::Specification.new do |s|
  s.name        = "dozens"
  s.version     = Dozens::VERSION
  s.authors     = ["CHIKURA Shinsaku"]
  s.email       = ["chsh@thinq.jp"]
  s.homepage    = ""
  s.summary     = %q{Dozens API for ruby}
  s.description = %q{Dozens API for ruby}

  s.rubyforge_project = "dozens"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

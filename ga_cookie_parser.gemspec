# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ga_cookie_parser/version"

Gem::Specification.new do |s|
  s.name        = "ga_cookie_parser"
  s.version     = GaCookieParser::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Robson"]
  s.email       = ["shrobson@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Google Analytics Cookie Parsing Gem}
  s.description = %q{Gem to parse the utmz, utmb and utma tracking coockies used by Google Analytics.}

  s.rubyforge_project = "ga_cookie_parser"
  
  s.add_development_dependency "shoulda"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "anagram_solver/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "anagram_solver"
  s.version     = AnagramSolver::VERSION.dup
  s.authors     = ["Antonio C Nalesso Moreira"]
  s.email       = ["acnalesso@yahoo.co.uk"]
  s.homepage    = "https://www.github.com/acnalesso/anagram_solver"
  s.summary     = "Reads a dictionary file and allows a user to find anagrams."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "mongoid"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
end

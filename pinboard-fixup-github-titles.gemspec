# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pinboard/fixup-github-titles/version'

Gem::Specification.new do |spec|
  spec.name          = "pinboard-fixup-github-titles"
  spec.version       = Pinboard::FixupGithubTitles::VERSION
  spec.authors       = ["Nicholas E. Rabenau"]
  spec.email         = ["nerab@gmx.at"]
  spec.summary       = %q{Fixup titles of github bookmarks in Pinboard}
#  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'octokit'
  spec.add_dependency 'pinboard'
  spec.add_dependency 'netrc'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
end

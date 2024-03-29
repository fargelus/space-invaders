# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/space_invaders/version'

Gem::Specification.new do |spec|
  spec.name          = 'space_invaders'
  spec.version       = SpaceInvaders::VERSION
  spec.authors       = ['fargelus']
  spec.email         = ['ddraudred@gmail.com']

  spec.summary       = 'Space Invaders classic 2d game'
  spec.description   = 'Space Invaders classic 2d game'
  spec.homepage      = 'https://github.com/fargelus/space-invaders'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'mongo', '~> 2.2.5'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'mdl'
end

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
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/fargelus/space-invaders/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob('lib/**/*') + Dir.glob('bin/**/*') + %w[README.md CHANGELOG.md]
  spec.bindir        = 'bin'
  spec.executables   = 'space_invaders'
  spec.require_paths = ['lib']

  spec.add_dependency 'gosu'
  # TODO Change to SQLite
  spec.add_dependency 'mongo', '~> 2.2.5'
end

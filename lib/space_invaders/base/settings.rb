# frozen_string_literal: true

require 'pathname'

module SpaceInvaders
  module Settings
    WIDTH = 800
    HEIGHT = 600
    CAPTION = 'Space Invaders'
    VERSION = '0.1.0'
    SPACESHIP_SPEED = 3
    BULLET_SPEED = 5
    ALIENS_TYPES_COUNT = 6
    ALIENS_ROWS = 4
    ALIENS_PER_ROW = 10
    ALIENS_MARGIN = 15
    ALIENS_HEIGHT = 32
    ASSETS_DIR = Pathname.new(__dir__).join('../../') / 'assets'
    IMAGES_PATH = ASSETS_DIR / 'images'
    SOUNDS_PATH = ASSETS_DIR / 'sounds'
    SOUNDS_VOLUME = 8
    ALIENS_DIR = IMAGES_PATH / 'invaders'
    ALIEN_TYPES = {
      predator: 'predator.png',
      octopus: 'octopus.png',
      mad_robot: 'mad_robot.png',
      robot: 'robot.png',
      skull: 'skull.png',
      smiley: 'smiley.png'
    }.freeze
    ALL_ALIENS = ALIEN_TYPES.values.map do |image_name|
      Pathname.new(ALIENS_DIR / image_name)
    end
  end
end

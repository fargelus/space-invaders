# frozen_string_literal: true

require 'pathname'

module SpaceInvaders
  module Settings
    WIDTH = 800
    HEIGHT = 600
    CAPTION = 'Space Invaders'
    VERSION = '0.1.0'
    SPACESHIP_SPEED = 3
    SPACESHIP_LIFES = 3
    BULLET_SPEED = 5
    BULLET_DIRECTION_UP = -1
    BULLET_DIRECTION_DOWN = 1
    ALIENS_ROWS = 5
    ALIENS_PER_ROW = 10
    ALIENS_MARGIN = 15
    LIFES_MARGIN = 5
    ALIENS_HEIGHT = 32
    ALIENS_WIDTH = 48
    BULLET_WIDTH = 6
    ASSETS_DIR = Pathname.new(__dir__).join('../../') / 'assets'
    IMAGES_PATH = ASSETS_DIR / 'images'
    BULLETS_DIR = IMAGES_PATH / 'bullets'
    SOUNDS_PATH = ASSETS_DIR / 'sounds'
    SOUNDS_VOLUME = 8
    ALIENS_DIR = IMAGES_PATH / 'invaders'
    ALIENS_PATH_TO_TYPE = {
      Pathname.new(ALIENS_DIR / 'spider_tiles.png') => :spider,
      Pathname.new(ALIENS_DIR / 'robot_tiles.png') => :robot,
      Pathname.new(ALIENS_DIR / 'skull_tiles.png') => :skull,
      Pathname.new(ALIENS_DIR / 'predator_tiles.png') => :predator
    }.freeze
    ALL_ALIENS = ALIENS_PATH_TO_TYPE.keys + [ALIENS_PATH_TO_TYPE.keys.last]
    ALIENS_SCOREBOARD = {
      predator: 10,
      robot: 20,
      skull: 30,
      spider: 50
    }.freeze
  end
end

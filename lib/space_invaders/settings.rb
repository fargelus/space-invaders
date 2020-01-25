# frozen_string_literal: true

require 'pathname'

module SpaceInvaders
  module Settings
    WIDTH = 640
    HEIGHT = 480
    CAPTION = 'Space Invaders'
    VERSION = '0.1.0'
    SPACESHIP_SPEED = 3
    ALIENS_TYPES_COUNT = 6
    ALIENS_ROWS = 4
    ALIENS_PER_ROW = 10
    ALIENS_MARGIN = 10
    ALIENS_HEIGHT = 32
    ASSETS_DIR = Pathname.new(__FILE__).join('../../') / 'assets'
    IMAGES_PATH = ASSETS_DIR / 'images'
    ALIENS_DIR = IMAGES_PATH / 'invaders'
    ALL_ALIENS = Pathname.new(ALIENS_DIR).children.map { |file| file }
  end
end

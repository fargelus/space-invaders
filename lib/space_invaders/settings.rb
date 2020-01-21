# frozen_string_literal: true

require 'pathname'

module SpaceInvaders
  module Settings
    VERSION = '0.1.0'
    WIDTH = 640
    HEIGHT = 480
    CAPTION = 'Space Invaders'
    ASSETS_PATH = Pathname.pwd.join('lib/assets')
    IMAGES_PATH = ASSETS_PATH / 'images'
    SPACESHIP_SPEED = 3
    ALIENS_TYPES_COUNT = 6
    ALIENS_ROWS = 4
    ALIENS_PER_ROW = 10
    ALIENS_MARGIN = 10
  end
end

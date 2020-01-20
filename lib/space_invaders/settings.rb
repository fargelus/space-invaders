# frozen_string_literal: true

require 'pathname'

module SpaceInvaders
  module Settings
    VERSION = '0.1.0'
    WIDTH = 640
    HEIGHT = 480
    CAPTION = 'Space Invaders'
    ASSETS_PATH = Pathname.pwd.join('assets')
    IMAGES_PATH = ASSETS_PATH / 'images'
    SPACESHIP_SPEED = 3
    INVADERS_TYPES_COUNT = 6
    TOTAL_INVADERS = 55
  end
end

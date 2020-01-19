# frozen_string_literal: true

require 'pathname'

module SpaceInvaders
  module Settings
    VERSION = '0.1.0'
    WIDTH = 640
    HEIGHT = 480
    CAPTION = 'Space Invaders'
    ASSETS_PATH = Pathname.pwd.join('assets')
    SPACESHIP_SPEED = 3

    def self.images_path(image)
      File.join(ASSETS_PATH, 'images', image)
    end
  end
end

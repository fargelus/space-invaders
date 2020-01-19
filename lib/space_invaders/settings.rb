# frozen_string_literal: true

module SpaceInvaders
  module Settings
    VERSION = '0.1.0'
    WIDTH = 640
    HEIGHT = 480
    CAPTION = 'Space Invaders'
    ASSETS_PATH = File.join(File.dirname(File.dirname(__FILE__)), 'assets')

    def self.images_path(image)
      File.join(ASSETS_PATH, 'images', image)
    end
  end
end

# frozen_string_literal: true

require 'pathname'

module SpaceInvaders
  module AssetsSettings
    ASSETS_DIR = Pathname.new(__FILE__).join('../../../') / 'assets'
    IMAGES_PATH = ASSETS_DIR / 'images'
    ALIENS_DIR = IMAGES_PATH / 'invaders'
  end
end

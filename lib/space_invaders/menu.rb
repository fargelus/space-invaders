# frozen_string_literal: true

require 'gosu'
require_relative 'settings'
require_relative 'game_objects/basic_object'
require_relative 'helpers'

module SpaceInvaders
  class Menu < Gosu::Window
    LOGO_IMG = Settings::IMAGES_PATH / 'logo.jpg'
    include Helpers

    def initialize(width = Settings::WIDTH,
                   height = Settings::HEIGHT)
      super
      self.caption = Settings::CAPTION
      @screen_width = width
      @screen_height = height

      @logo = BasicObject.new(0, 0, LOGO_IMG)
      @logo.set(horizontal_center(@logo), @screen_height * 0.6)
    end

    def draw
      @logo.draw
    end
  end
end

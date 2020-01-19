# frozen_string_literal: true

require 'gosu'
require_relative 'space_invaders/ship'

module SpaceInvaders
  class Game < Gosu::Window
    def initialize(width = Settings::WIDTH,
                   height = Settings::HEIGHT)
      super
      self.caption = Settings::CAPTION

      setup_bg
      @ship = Ship.new(0, 0)
    end

    def draw
      @bg.draw(0, 0, 0)
      @ship.draw
    end

    private

    def setup_bg
      bg_image = Settings.images_path('space.png')
      @bg = Gosu::Image.new(bg_image)
    end
  end
end

game = SpaceInvaders::Game.new
game.show

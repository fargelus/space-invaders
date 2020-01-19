# frozen_string_literal: true

require 'gosu'
require_relative 'space_invaders/ship'

module SpaceInvaders
  class Game < Gosu::Window
    def initialize(width = Settings::WIDTH,
                   height = Settings::HEIGHT)
      super
      self.caption = Settings::CAPTION
      @width = width
      @height = height
      @draws = 0
      @movements = 0

      setup_bg
      setup_assets
    end

    def update
      @ship.set(@ship.x - 3, @ship.y) if move_ship_left?
      @ship.set(@ship.x + 3, @ship.y) if move_ship_right?
    end

    def move_ship_left?
      button_down?(Gosu::KbLeft) && @ship.x > 0
    end

    def move_ship_right?
      button_down?(Gosu::KbRight) && @ship.x + @ship.w < @width
    end

    def button_down(id)
      close if id == Gosu::KbEscape
      @movements += 1
    end

    def button_up(_id)
      @movements -= 1
    end

    def draw
      @draws += 1
      @bg.draw(0, 0, 0)
      @ship.draw
    end

    def needs_redraw?
      @draws == 0 || @movements > 0
    end

    private

    def setup_bg
      bg_image = Settings.images_path('space.png')
      @bg = Gosu::Image.new(bg_image)
    end

    def setup_assets
      @ship = Ship.new
      @ship.set(@width / 2 - @ship.w / 2,
                @height * 0.9 - @ship.h / 2)
    end
  end
end

game = SpaceInvaders::Game.new
game.show

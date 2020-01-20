# frozen_string_literal: true

require 'gosu'
require_relative 'space_invaders/ship'
require_relative 'space_invaders/alien'

module SpaceInvaders
  class Game < Gosu::Window
    def initialize(width = Settings::WIDTH,
                   height = Settings::HEIGHT)
      super
      self.caption = Settings::CAPTION
      @screen_width = width
      @screen_height = height
      @draws = 0
      @ship = Ship.new
      @alien = Alien.new
      @game_objects = [@ship]

      setup_bg
      setup_assets
    end

    def update
      @ship.move_left! if button_down?(Gosu::KbLeft)
      @ship.move_right! if button_down?(Gosu::KbRight)
    end

    def button_down(id)
      close if id == Gosu::KbEscape
    end

    def draw
      @draws += 1
      @bg.draw(0, 0, 0)
      @ship.draw
      @alien.draw
    end

    def needs_redraw?
      @draws == 0 || @game_objects.any?(&:needs_redraw?)
    end

    private

    def setup_bg
      bg_image = Settings::IMAGES_PATH / 'space.png'
      @bg = Gosu::Image.new(bg_image.to_s)
    end

    def setup_assets
      @ship.set(
        @screen_width / 2 - @ship.w / 2,
        @screen_height * 0.9 - @ship.h / 2,
        [0, @screen_width]
      )
    end
  end
end

game = SpaceInvaders::Game.new
game.show

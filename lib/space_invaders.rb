# frozen_string_literal: true

require 'gosu'
require_relative 'space_invaders/settings'
require_relative 'space_invaders/ship'
require_relative 'space_invaders/aliens'

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
      @aliens = Aliens.new(@screen_width * 0.05)
      @bg = GameObject.new(0, 0, Settings::IMAGES_PATH / 'space.png')
      @game_objects = [@ship]

      setup_assets
    end

    def update
      @ship.move_left! if button_down?(Gosu::KbLeft)
      @ship.move_right! if button_down?(Gosu::KbRight)
      @ship.shoot(@aliens.first_row) if button_down?(Gosu::KbSpace)
    end

    def button_down(id)
      close if id == Gosu::KbEscape
    end

    def draw
      @draws += 1
      @bg.draw
      @ship.draw
      @aliens.draw
    end

    def needs_redraw?
      @draws == 0 || @game_objects.any?(&:needs_redraw?)
    end

    private

    def setup_assets
      setup_ship
      @aliens.setup
    end

    def setup_ship
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

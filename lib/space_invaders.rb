# frozen_string_literal: true

require 'gosu'
require_relative 'space_invaders/settings'
require_relative 'space_invaders/ship'
require_relative 'space_invaders/aliens'
require_relative 'space_invaders/scores/player_score'
require_relative 'space_invaders/scores/hi_score'

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
      @aliens = Aliens.new(@screen_width * 0.1, @screen_height * 0.15)
      @bg = GameObject.new(0, 0, Settings::IMAGES_PATH / 'space.png')
      @game_objects = [@ship]
      @scores = []

      setup_scores
      setup_assets
    end

    def update
      @ship.move_left! if button_down?(Gosu::KbLeft)
      @ship.move_right! if button_down?(Gosu::KbRight)
      @ship.shoot if button_down?(Gosu::KbSpace)
    end

    def button_down(id)
      close if id == Gosu::KbEscape
    end

    def draw
      @draws += 1
      @bg.draw
      @ship.draw
      @aliens.draw
      @scores.each(&:draw)
    end

    def needs_redraw?
      @draws.zero? || @game_objects.any?(&:needs_redraw?)
    end

    private

    def setup_scores
      scores_y = 15
      @scores << PlayerScore.new(x: @screen_width * 0.05, y: scores_y, window: self)
      @scores << HiScore.new(x: @screen_width * 0.7, y: scores_y, window: self)
    end

    def setup_assets
      @aliens.setup
      setup_ship
    end

    def setup_ship
      @ship.enemies = @aliens
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

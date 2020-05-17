# frozen_string_literal: true

require 'gosu'
require_relative 'base/settings'
require_relative 'db/setup'
require_relative 'aliens'
require_relative 'scores/player_score'
require_relative 'scores/hi_score'
require_relative 'game_objects/ship'
require_relative 'game_objects/lifes'

module SpaceInvaders
  class Game < Gosu::Window
    def initialize(width = Settings::WIDTH,
                   height = Settings::HEIGHT)
      super
      self.caption = Settings::CAPTION
      @screen_width = width
      @screen_height = height

      @ship = Ship.new
      @aliens = Aliens.new(@screen_width * 0.1, @screen_height * 0.1)
      @bg = GameObject.new(0, 0, Settings::IMAGES_PATH / 'space.png')
      @game_objects = [@ship, @aliens]
      @last_shoot_time = Gosu.milliseconds

      setup_scores
      setup_assets
    end

    def update
      @ship.move_left! if button_down?(Gosu::KbLeft)
      @ship.move_right! if button_down?(Gosu::KbRight)
      @ship.shoot if button_down?(Gosu::KbSpace)
    end

    def button_down(id)
      save_score_and_close if id == Gosu::KbEscape
    end

    def draw
      @bg.draw
      @ship.draw
      @player_score.up(@aliens.last_killed)
      @aliens.draw
      @scores.each(&:draw)
      @lifes.draw(@ship.lifes)

      if aliens_need_shoot?
        @aliens.shoot(@ship)
        @last_shoot_time = Gosu.milliseconds
      end
    end

    def needs_redraw?
      @game_objects.collect(&:needs_redraw?).any?
    end

    private

    def setup_scores
      scores_y = 15
      @scores = []
      @player_score = PlayerScore.new(
        x: @screen_width * 0.05,
        y: scores_y,
        window: self
      )
      @scores << @player_score
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
        @screen_height * 0.85 - @ship.h / 2,
        [0, @screen_width]
      )
      @lifes = Lifes.new(@screen_width * 0.05, @screen_height * 0.94)
    end

    def save_score_and_close
      #   document = { score: @player_score.current }
      #   DB::SCORES_COLLECTION.insert_one(document)
      # rescue Mongo::Error::OperationFailure
      #   nil
      # ensure
      close
    end

    def aliens_need_shoot?
      Gosu.milliseconds - @last_shoot_time > Settings::ALIENS_DELAY_SHOOT_MSEC
    end
  end
end

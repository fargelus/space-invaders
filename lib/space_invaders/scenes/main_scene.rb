# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/game_scene'
require_relative '../aliens'
require_relative '../scores/player_score'
require_relative '../scores/hi_score'
require_relative '../game_objects/ship'
require_relative '../game_objects/lifes'

module SpaceInvaders
  class MainScene < GameScene
    def initialize(width:, height:, window:)
      super

      @screen_width = width
      @screen_height = height

      prepare_scene
    end

    def update
      @ship.move_left! if @window.button_down?(Gosu::KbLeft)
      @ship.move_right! if @window.button_down?(Gosu::KbRight)
      @ship.shoot if @window.button_down?(Gosu::KbSpace)
    end

    def button_down(id)
      save_score_and_close if id == Gosu::KbEscape
    end

    def draw
      super

      @redraw_objects.each(&:draw)
      @lifes.draw(@ship.lifes)
      @scores.each(&:draw)

      @need_final_drawing = @aliens.first_row_y >= @ship.start_y

      @player_score.up(@aliens.last_killed)
    end

    def needs_redraw?
      @aliens_reached_ship = @need_final_drawing
      @redraw_objects.collect(&:needs_redraw?).any?
    end

    def needs_change?
      @ship.lifes.zero? || aliens_reached_ship?
    end

    def aliens_reached_ship?
      @need_final_drawing = false if @aliens_reached_ship
      @aliens_reached_ship
    end

    def prepare_scene
      super

      @ship = Ship.new
      @aliens = Aliens.new(
        coord_x: @screen_width * 0.1,
        coord_y: @screen_height * 0.1,
        enemy: @ship
      )
      @redraw_objects = [@ship, @aliens]
      setup_assets
    end

    private

    def setup_assets
      setup_scores
      @aliens.setup
      setup_ship
    end

    def setup_scores
      scores_y = 15
      @player_score = PlayerScore.new(
        x: @screen_width * 0.05,
        y: scores_y,
        window: @window
      )
      hi_score_params = { x: @screen_width * 0.7, y: scores_y, window: @window }
      @scores = [@player_score, HiScore.new(hi_score_params)]
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
      document = { score: @player_score.current }
      DB::SCORES_COLLECTION.insert_one(document)
    rescue Mongo::Error::OperationFailure
      nil
    ensure
      @window.close
    end
  end
end

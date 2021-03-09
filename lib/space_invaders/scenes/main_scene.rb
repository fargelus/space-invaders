# frozen_string_literal: true

require 'gosu'
require_relative '../db/operations'
require_relative '../base/game_scene'
require_relative '../base/timer'
require_relative '../base/settings'
require_relative '../aliens'
require_relative '../scores/player_score'
require_relative '../scores/hi_score'
require_relative '../game_objects/image_objects/ship'
require_relative '../game_objects/image_objects/lifes'
require_relative '../game_objects/ground'
require_relative '../game_objects/image_objects/ammo'

module SpaceInvaders
  class MainScene < GameScene
    ALIENS_NEW_WAVE_RENDER_PAUSE = 400
    include Settings

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
      @aliens.shoot(obstacle: @ground) if @aliens.need_shoot?
    end

    def button_down(id)
      save_score_and_close if id == Gosu::KbEscape
    end

    def draw
      super

      @current_user ||= DBOperations.current_user
      @aliens.setup if new_aliens_wave?

      @redraw_objects.each(&:draw)
      @lifes.draw(@ship.lifes)
      @ground.draw
      @player_score.up(@aliens.last_killed)
      @scores.each { |score| score.draw(@current_user) }

      return if @aliens.destroyed?

      @need_final_drawing = @aliens.first_row_y >= @ship.start_y
    end

    def needs_redraw?
      @aliens_reached_ship = @need_final_drawing
      @redraw_objects.collect(&:needs_redraw?).any? || @aliens.destroyed?
    end

    def needs_change?
      @ship.destroyed? || aliens_reached_ship?
    end

    def aliens_reached_ship?
      @need_final_drawing = false if @aliens_reached_ship
      @aliens_reached_ship
    end

    def prepare_scene
      super

      @ammos = {
        ship: Ammo.new(ship_ammo_options),
        aliens: []
      }
      @ship = Ship.new(ammo: @ammos[:ship])
      @aliens = Aliens.new(
        coord_x: @screen_width * 0.1,
        coord_y: @screen_height * 0.15,
        enemy: @ship
      )
      @ground = Ground.new(0, @screen_height * 0.93)
      @redraw_objects = [@ship, @aliens]
      setup_assets
    end

    private

    def setup_assets
      setup_scores
      setup_aliens
      setup_ship
    end

    def setup_scores
      scores_y = 10
      @player_score = PlayerScore.new(
        x: @screen_width * 0.05,
        y: scores_y,
        window: @window
      )
      hi_score_params = { x: @screen_width * 0.7, y: scores_y, window: @window }
      @scores = [@player_score, HiScore.new(hi_score_params)]
    end

    def setup_aliens
      @aliens.setup
      @aliens.each do |alien|
        ammo = Ammo.new(alien_ammo_options(alien.type))
        alien.gun = ammo
        @ammos[:aliens] << ammo
      end
    end

    def setup_ship
      @ship.enemies = @aliens
      @ship.set(
        @screen_width / 2 - @ship.w / 2,
        @screen_height * 0.85 - @ship.h / 2,
        [0, @screen_width]
      )
      @lifes = Lifes.new(@screen_width * 0.05, @screen_height * 0.95)
    end

    def save_score_and_close
      DBOperations.insert(score: @player_score.current, user: @current_user)
    rescue DBOperations::Errors::OperationFailure
      nil
    ensure
      @window.close
    end

    def new_aliens_wave?
      @aliens.destroyed? && Timer.overtime?(ALIENS_NEW_WAVE_RENDER_PAUSE)
    end
  end
end

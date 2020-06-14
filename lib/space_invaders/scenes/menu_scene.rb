# frozen_string_literal: true

require 'gosu'
require_relative '../output/printable_text'
require_relative '../base/settings'
require_relative '../game_objects/alien'

module SpaceInvaders
  class MenuScene < GameScene
    SCORE_TABLE_RENDER_DELAY_MSEC = 200
    include Settings

    def initialize(width:, height:, window:)
      super

      prepare_scene

      @main_font = Gosu::Font.new(@window, FONT, INFO_FONT_SIZE)
      @label_font = Gosu::Font.new(@window, FONT, LABEL_FONT_SIZE)
    end

    def needs_redraw?
      return true if [@entrance_text, @game_title].any?(:needs_redraw?)

      @printable_aliens_scores.empty? || @printable_aliens_scores.find(&:needs_redraw?)
    end

    def draw
      super

      @entrance_text.draw
      @game_title.draw unless @entrance_text.needs_redraw?
      draw_score_table if score_table_needs_draw?
      @label_font.draw_text(
        'Press <Enter> to continue',
        @width * 0.35, @height * 0.95,
        0, 1.0, 1.0
      )
    end

    def button_down(id)
      @change = (id == Gosu::KbReturn)
    end

    def prepare_scene
      super

      @entrance_text = PrintableText.new(
        x: @width * 0.45,
        y: @height * 0.15,
        text: 'Play',
        window: @window,
        color: GREEN_COLOR,
        size: INFO_FONT_SIZE
      )
      @game_title = PrintableText.new(
        x: @width * 0.33,
        y: @height * 0.25,
        size: INFO_FONT_SIZE,
        color: GREEN_COLOR,
        text: CAPTION,
        window: @window
      )
      @printable_aliens_scores = []
      @aliens_draw_info = []
    end

    private

    def score_table_needs_draw?
      return false if @game_title.needs_redraw?
      return true if @printable_aliens_scores.any?

      @delay_timestamp ||= Gosu.milliseconds
      Gosu.milliseconds - @delay_timestamp > SCORE_TABLE_RENDER_DELAY_MSEC
    end

    def draw_score_table
      draw_instant_score_table_items
      fill_printable_aliens_scores if @printable_aliens_scores.empty?
      draw_aliens_score
    end

    def draw_instant_score_table_items
      render_height = @height * 0.43
      @main_font.draw_text(
        '*Score advance table*',
        @width * 0.23, render_height,
        0, 1.0, 1.0,
        SUNNY_COLOR
      )

      aliens_render_x = @width * 0.33
      ALIENS_SCOREBOARD.each do |alien_type, score_points|
        alien_path = ALIENS_PATH_TO_TYPE.key(alien_type)
        render_height += ALIENS_HEIGHT + ALIENS_MARGIN + 5
        Alien.new(aliens_render_x, render_height, alien_path).draw
        @aliens_draw_info << {
          x: aliens_render_x,
          y: render_height,
          points: score_points
        }
      end
    end

    def fill_printable_aliens_scores
      @aliens_draw_info.each do |alien_info|
        @printable_aliens_scores << PrintableText.new(
          x: alien_info[:x] + ALIENS_WIDTH + ALIENS_MARGIN,
          y: alien_info[:y],
          text: "= #{alien_info[:points]} points",
          window: @window,
          size: INFO_FONT_SIZE
        )
      end
    end

    def draw_aliens_score
      @printable_aliens_scores.reject(&:needs_redraw?).each(&:draw)
      @printable_aliens_scores.find(&:needs_redraw?)&.draw
    end
  end
end

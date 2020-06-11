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

      @font_size = 40
      @entrance_text = Gosu::Font.new(
        @window,
        DEFAULT_FONT,
        @font_size
      )
      @game_title = PrintableText.new(
        x: width * 0.33,
        y: height * 0.25,
        size: @font_size,
        color: GREEN_COLOR,
        text: CAPTION,
        window: window
      )
      @score_table_title = Gosu::Font.new(
        @window,
        DEFAULT_FONT,
        @font_size
      )
      @aliens_draw_info = []
      @printable_aliens_scores = []
    end

    def needs_redraw?
      return true if @game_title.needs_redraw?
      return unless @game_title.print_finished?
      return true if @printable_aliens_scores.empty?

      true
    end

    def draw
      super

      @entrance_text.draw_text(
        'Play',
        @width * 0.46, @height * 0.15,
        0, 1.0, 1.0,
        GREEN_COLOR
      )
      @game_title.draw
      return unless @game_title.print_finished?
      return unless score_table_needs_draw?

      draw_instant_score_table_items
      fill_printable_aliens_scores if @printable_aliens_scores.empty?
      draw_aliens_score
    end

    private

    def score_table_needs_draw?
      return true if @printable_aliens_scores.any?

      @delay_timestamp ||= Gosu.milliseconds
      Gosu.milliseconds - @delay_timestamp > SCORE_TABLE_RENDER_DELAY_MSEC
    end

    def draw_instant_score_table_items
      render_height = @height * 0.43
      @score_table_title.draw_text(
        '*Score advance table*',
        @width * 0.23, render_height,
        0, 1.0, 1.0,
        SUNNY_COLOR
      )

      aliens_render_x = @width * 0.3
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
          size: @font_size
        )
      end
    end

    def draw_aliens_score
      @printable_aliens_scores.select(&:print_finished?).each(&:draw)
      @printable_aliens_scores.reject(&:print_finished?)
                              .first
                              &.draw
    end
  end
end

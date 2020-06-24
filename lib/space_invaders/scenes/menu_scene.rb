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

      @printable_scores.empty? || @printable_scores.find(&:needs_redraw?)
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

      @entrance_text = PrintableText.new(entrance_text_options)
      @game_title = PrintableText.new(game_title_options)
      @printable_scores = []
      @aliens_draw_info = []
    end

    private

    def entrance_text_options
      {
        x: @width * 0.45,
        y: @height * 0.1,
        text: 'Play',
        window: @window,
        color: GREEN_COLOR,
        size: INFO_FONT_SIZE
      }
    end

    def game_title_options
      {
        x: @width * 0.33,
        y: @height * 0.2,
        size: INFO_FONT_SIZE,
        color: GREEN_COLOR,
        text: CAPTION,
        window: @window
      }
    end

    def score_table_needs_draw?
      return false if @game_title.needs_redraw?
      return true if @printable_scores.any?

      @delay_timestamp ||= Gosu.milliseconds
      Gosu.milliseconds - @delay_timestamp > SCORE_TABLE_RENDER_DELAY_MSEC
    end

    def draw_score_table
      table_header_coord_y = @height * 0.35
      @main_font.draw_text(
        '*Score advance table*',
        @width * 0.23, table_header_coord_y,
        0, 1.0, 1.0,
        SUNNY_COLOR
      )
      @aliens_render_coords = {
        x: @width * 0.33,
        y: table_header_coord_y + ALIENS_HEIGHT + ALIENS_MARGIN + 5
      }
      draw_aliens
      draw_aliens_score
    end

    def draw_aliens
      %i[mistery predator robot skull spider].each do |alien_type|
        alien_path = ALIENS_PATH_TO_TYPE.key(alien_type)
        coord_x, coord_y = @aliens_render_coords.values
        Alien.new(coord_x, coord_y, alien_path).draw
        @aliens_draw_info << {
          x: coord_x,
          y: coord_y,
          points: ALIENS_SCOREBOARD[alien_type]
        }
        alien_rendered
      end
    end

    def alien_rendered
      @aliens_render_coords[:y] += ALIENS_HEIGHT + ALIENS_MARGIN + 5
    end

    def draw_aliens_score
      fill_printable_scores if @printable_scores.empty?

      @printable_scores.reject(&:needs_redraw?).each(&:draw)
      @printable_scores.find(&:needs_redraw?)&.draw
    end

    def fill_printable_scores
      @aliens_draw_info.each do |alien_info|
        alien_info[:points] ||= '?'
        @printable_scores << PrintableText.new(
          x: alien_info[:x] + ALIENS_WIDTH + ALIENS_MARGIN,
          y: alien_info[:y],
          text: "= #{alien_info[:points]} points",
          window: @window,
          size: INFO_FONT_SIZE
        )
      end
    end
  end
end
# frozen_string_literal: true

require 'gosu'
require_relative '../../output/printable_text'
require_relative '../../base/timer'

module SpaceInvaders
  class AliensScene < GameScene
    SCORE_TABLE_RENDER_DELAY_MSEC = 200

    def initialize(width:, height:, window:)
      super

      @printable_scores = []
      @aliens_draw_info = []
    end

    def needs_redraw?
      @printable_scores.empty? || @printable_scores.find(&:needs_redraw?)
    end

    def draw
      super

      draw_score_table if score_table_needs_draw?
    end

    private

    def score_table_needs_draw?
      return true if @printable_scores.any?

      Timer.overtime?(SCORE_TABLE_RENDER_DELAY_MSEC)
    end

    def draw_score_table
      table_header_coord_y = @height * 0.35
      @main_font.draw_text(
        '*Score advance table*',
        @width * 0.23, table_header_coord_y,
        0, 1.0, 1.0,
        SUNNY_COLOR
      )
      draw_aliens(table_header_coord_y)
      draw_aliens_score
    end

    def draw_aliens(table_header_coord_y)
      @aliens_render_coords = {
        x: @width * 0.33,
        y: table_header_coord_y + ALIENS_HEIGHT + ALIENS_MARGIN + 5
      }
      %i[mistery predator robot skull spider].each do |alien_type|
        draw_alien(alien_type)
      end
    end

    def draw_alien(alien_type)
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

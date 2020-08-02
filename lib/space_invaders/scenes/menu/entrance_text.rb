# frozen_string_literal: true

require_relative '../../base/settings'
require_relative '../../output/printable_text'

module SpaceInvaders
  class MenuEntranceText
    include Settings

    def initialize(start_x:, start_y:, window:)
      @start_x = start_x
      @start_y = start_y
      @window = window
      @entrance_phrases = [
        PrintableText.new(entrance_text_options),
        PrintableText.new(game_title_options)
      ]
    end

    def draw
      @entrance_phrases[0].draw
      @entrance_phrases[1].draw unless @entrance_phrases.first.needs_redraw?
    end

    def needs_redraw?
      @entrance_phrases.any?(&:needs_redraw?)
    end

    private

    def entrance_text_options
      {
        x: @start_x,
        y: @start_y,
        text: 'Play',
        window: @window,
        color: GREEN_COLOR,
        size: INFO_FONT_SIZE
      }
    end

    def game_title_options
      entrance_text_options.merge(
        x: @start_x - CAPTION_FONT_SIZE - INFO_FONT_SIZE,
        y: @start_y + INFO_FONT_SIZE,
        text: CAPTION
      )
    end
  end
end

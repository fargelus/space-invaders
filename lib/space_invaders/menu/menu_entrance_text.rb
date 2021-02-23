# frozen_string_literal: true

require_relative '../base/settings'
require_relative '../output/printable_text'
require_relative '../base/image_object'

module SpaceInvaders
  class MenuEntranceText
    include Settings

    attr_reader :last_y

    def initialize(options)
      @x = options.fetch(:x)
      @y = options.fetch(:y)
      @window = options.fetch(:window)
      @font_size = options.fetch(:font_size)
      @entrance_phrases = [
        PrintableText.new(entrance_text_options),
        PrintableText.new(game_title_options)
      ]
    end

    def draw
      @entrance_phrases[0].draw
      @entrance_phrases[1].draw unless @entrance_phrases[0].needs_redraw?

      draw_logo unless @entrance_phrases[1].needs_redraw?
    end

    def needs_redraw?
      @entrance_phrases.any?(&:needs_redraw?)
    end

    private

    def entrance_text_options
      {
        x: @x,
        y: @y,
        text: 'Play',
        window: @window,
        color: GREEN_COLOR,
        size: @font_size
      }
    end

    def game_title_options
      entrance_text_options.merge(
        x: @x - CAPTION_FONT_SIZE - @font_size,
        y: @y + @font_size,
        text: CAPTION
      )
    end

    def draw_logo
      logo_x = game_title_options[:x]
      logo_y = game_title_options[:y] + INFO_FONT_SIZE
      ImageObject.new(logo_x, logo_y, ALIENS_DIR / 'invaders_logo.png').draw
      @last_y = logo_y + ALIENS_HEIGHT
    end
  end
end

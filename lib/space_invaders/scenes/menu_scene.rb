# frozen_string_literal: true

require 'gosu'
require_relative '../output/printable_text'
require_relative '../base/settings'

module SpaceInvaders
  class MenuScene < GameScene
    def initialize(width:, height:, window:)
      super

      @font_size = 40
      @entrance_text = Gosu::Font.new(
        @window,
        Settings::DEFAULT_FONT,
        @font_size
      )
      @game_title = PrintableText.new(
        x: width * 0.33,
        y: height * 0.3,
        size: @font_size,
        color: Settings::GREEN_COLOR,
        text: Settings::CAPTION,
        window: window
      )
    end

    def needs_redraw?
      @game_title.needs_redraw?
    end

    def draw
      super

      @entrance_text.draw_text(
        'Play',
        @width * 0.46, @height * 0.2, 0, 1.0, 1.0,
        Settings::GREEN_COLOR
      )
      @game_title.draw
    end
  end
end

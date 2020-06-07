# frozen_string_literal: true

require_relative '../output/printable_text'
require_relative '../base/settings'

module SpaceInvaders
  class MenuScene < GameScene
    def initialize(width:, height:, window:)
      super

      @font_size = 40
      @game_title = PrintableText.new(
        x: width * 0.35,
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
      @game_title.draw
    end
  end
end

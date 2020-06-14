# frozen_string_literal: true

require_relative '../output/printable_text'
require_relative '../base/settings'
require_relative '../base/game_scene'

module SpaceInvaders
  class GameOverScene < GameScene
    def initialize(width:, height:, window:)
      super

      prepare_scene
      @label_font = Gosu::Font.new(
        @window,
        Settings::FONT,
        Settings::LABEL_FONT_SIZE
      )
    end

    def draw
      super
      @game_over_msg.draw
      @label_font.draw_text(
        'Press <Enter> to restart game',
        @width * 0.33, @height * 0.4,
        0, 1.0, 1.0
      )
    end

    def needs_redraw?
      @game_over_msg.needs_redraw?
    end

    def button_down(id)
      @change = (id == Gosu::KbReturn)
    end

    def prepare_scene
      super

      @game_over_msg = PrintableText.new(
        x: @width * 0.33,
        y: @height * 0.3,
        text: 'Game Over',
        size: 55,
        color: Settings::RED_COLOR,
        window: @window
      )
    end
  end
end

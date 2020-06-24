# frozen_string_literal: true

require 'gosu'
require_relative '../output/printable_text'
require_relative '../base/settings'
require_relative '../base/game_scene'

module SpaceInvaders
  class GameOverScene < GameScene
    LABEL_DRAW_DELAY = 150

    def initialize(width:, height:, window:)
      super

      prepare_scene
    end

    def draw
      super
      @game_over_msg.draw
      return if @game_over_msg.needs_redraw?

      @timestamp ||= Gosu.milliseconds
      if Gosu.milliseconds - @timestamp > LABEL_DRAW_DELAY
        @label_font.draw_text(
          'Press <Enter> to restart game',
          @width * 0.33, @height * 0.4,
          0, 1.0, 1.0
        )
        @draw_continues
      end
    end

    def needs_redraw?
      @draw_continues
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
      @label_font = Gosu::Font.new(
        @window,
        Settings::FONT,
        Settings::LABEL_FONT_SIZE
      )
      @draw_continues = true
    end
  end
end

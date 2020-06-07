# frozen_string_literal: true

require_relative '../output/printable_text'
require_relative '../base/settings'
require_relative '../base/game_scene'

module SpaceInvaders
  class GameOverScene < GameScene
    def initialize(width:, height:, window:)
      super

      @game_over_msg = PrintableText.new(
        x: width * 0.33,
        y: height * 0.3,
        text: 'Game Over',
        size: 55,
        color: Settings::RED_COLOR,
        window: window
      )
    end

    def draw
      super
      @game_over_msg.draw
    end

    def needs_redraw?
      @game_over_msg.needs_redraw?
    end
  end
end

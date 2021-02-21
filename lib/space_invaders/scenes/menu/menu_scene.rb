# frozen_string_literal: true

require 'gosu'
require_relative '../../output/printable_text'
require_relative '../../base/settings'
require_relative '../../base/timer'
require_relative '../../menu/entrance_text'
require_relative '../../menu/menu'

module SpaceInvaders
  class MenuScene < GameScene
    include Settings

    MAIN_MENU_RENDER_DELAY_MSEC = 200

    def initialize(width:, height:, window:)
      super

      prepare_scene
      @entrance_text = MenuEntranceText.new(
        start_x: @width * 0.45,
        start_y: @height * 0.1,
        window: @window
      )

      @menu = Menu.new(window)
      @menu.add_item(text: 'New Game', x: @width * 0.4, y: @height * 0.3)
      @menu.add_item(text: 'Load Game', x: @width * 0.385, y: @height * 0.39)
      @menu.add_item(text: 'Leaderboard', x: @width * 0.385, y: @height * 0.47)
      @menu.add_item(text: 'Aliens', x: @width * 0.385, y: @height * 0.55)
      @menu.add_item(text: 'Exit', x: @width * 0.385, y: @height * 0.63)
    end

    def needs_redraw?
      return true if @entrance_text.needs_redraw?

      @menu.needs_redraw?
    end

    def draw
      super

      @entrance_text.draw
      @menu.draw if menu_needs_to_draw?
    end

    private

    def menu_needs_to_draw?
      return false if @entrance_text.needs_redraw?

      Timer.overtime?(MAIN_MENU_RENDER_DELAY_MSEC)
    end
  end
end

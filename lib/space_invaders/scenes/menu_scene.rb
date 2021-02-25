# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/timer'
require_relative '../menu/menu_entrance_text'
require_relative '../menu/menu'

module SpaceInvaders
  class MenuScene < GameScene
    include Settings

    MAIN_MENU_RENDER_DELAY_MSEC = 200

    def initialize(width:, height:, window:)
      super

      prepare_scene
      @entrance_text = MenuEntranceText.new(
        x: @width * 0.45,
        y: @height * 0.1,
        font_size: INFO_FONT_SIZE,
        window: @window
      )

      @menu = Menu.new(window, INFO_FONT_SIZE)
      @menu.add_item('New Game')
      @menu.add_item('Load Game')
      @menu.add_item('Leaderboard')
      @menu.add_item('Aliens')
      @menu.add_item('Exit')
    end

    def needs_redraw?
      return true if @entrance_text.needs_redraw?

      @menu.needs_redraw?
    end

    def draw
      super

      @entrance_text.draw
      return unless menu_needs_to_draw?

      @menu.draw(
        @width * 0.4,
        @entrance_text.last_y + INFO_FONT_SIZE * 1.5
      )
      @drawed = true
    end

    def button_down(id)
      return if @menu.needs_redraw?

      @menu.next_item if id == Gosu::KbDown
      @menu.previous_item if id == Gosu::KbUp
    end

    private

    def menu_needs_to_draw?
      return false if @entrance_text.needs_redraw?
      return true if @drawed

      Timer.overtime?(MAIN_MENU_RENDER_DELAY_MSEC)
    end
  end
end

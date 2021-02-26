# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/timer'
require_relative '../menu/menu_entrance_text'
require_relative '../menu/menu'
require_relative '../menu/aliens_scoreboard'

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
      @menu.add_item('New Game', callback: method(:new_game))
      @menu.add_item('Load Game', callback: method(:load_game))
      @menu.add_item('Leaderboard', callback: method(:show_leaderboard))
      @menu.add_item('Aliens', callback: method(:show_aliens_scoreboard))
      @menu.add_item('Exit', callback: method(:exit_game))

      @aliens_scoreboard = AliensScoreboard.new(@window, INFO_FONT_SIZE)
      @content = [@menu]
    end

    def needs_redraw?
      return true if @entrance_text.needs_redraw?

      @content.last.needs_redraw?
    end

    def draw
      super

      @entrance_text.draw
      return unless menu_needs_to_draw?

      draw_content
      @drawed = true
    end

    def button_down(id)
      return if @menu.needs_redraw?

      @menu.next_item if id == Gosu::KbDown
      @menu.previous_item if id == Gosu::KbUp
      @menu.run_command if id == Gosu::KbReturn
      @content.push(@menu) if id == Gosu::KbBackspace
    end

    private

    def menu_needs_to_draw?
      return false if @entrance_text.needs_redraw?
      return true if @drawed

      Timer.overtime?(MAIN_MENU_RENDER_DELAY_MSEC)
    end

    def draw_content
      @content.last.draw(*content_drawing_options)
    end

    def exit_game
      @window.close
    end

    def show_aliens_scoreboard
      @content.push(@aliens_scoreboard)
    end

    def content_drawing_options
      coord_y = @entrance_text.last_y + INFO_FONT_SIZE * 1.5
      coord_x = case @content.last
                when @menu
                  @width * 0.4
                when @aliens_scoreboard
                  @width * 0.25
                end
      [coord_x, coord_y]
    end

    def new_game
      puts 'NEW GAME!!!'
    end

    def load_game
      puts 'LOAD GAME!!!'
    end

    def show_leaderboard
      puts 'LEADERBOARD!!!'
    end
  end
end

# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/timer'
require_relative '../menu/menu_entrance_text'
require_relative '../menu/menu'
require_relative '../menu/aliens_scoreboard'
require_relative '../menu/new_game'
require_relative '../menu/leaderboard'
require_relative '../menu/continue_game'
require_relative '../menu/load_game'

module SpaceInvaders
  class MenuScene < GameScene
    include Settings

    MAIN_MENU_RENDER_DELAY_MSEC = 200
    FRAMES_MAX_SIZE = 2

    def initialize(width:, height:, window:)
      super
      prepare_scene

      @entrance_text = MenuEntranceText.new(
        x: @width * 0.45,
        y: @height * 0.1,
        font_size: INFO_FONT_SIZE,
        window: @window
      )

      @aliens_scoreboard = AliensScoreboard.new(window, INFO_FONT_SIZE)
      @label_font = Gosu::Font.new(window, FONT, LABEL_FONT_SIZE)
      @new_game = NewGame.new(window, INFO_FONT_SIZE - 10)
      @leaderboard = Leaderboard.new(window, INFO_FONT_SIZE - 15)
      @continue_game = ContinueGame.new(window, INFO_FONT_SIZE)
      @load_game = LoadGame.new(window, INFO_FONT_SIZE - 10)

      @menu = Menu.new(window, INFO_FONT_SIZE)
      add_menu_items

      @frames = [@menu]
    end

    def needs_redraw?
      return true if @entrance_text.needs_redraw?

      @frames.last.needs_redraw? || @frames.size > FRAMES_MAX_SIZE
    end

    def draw
      super

      @entrance_text.draw
      return unless menu_needs_to_draw?

      draw_current_frame
      @drawed = true
    end

    def button_down(id)
      return if button_down_handled_by_frames?(id) || @menu.needs_redraw?

      @menu.button_down(id) if @frames.last == @menu
      @frames.push(@menu) if id == Gosu::KbEscape
    end

    private

    def add_menu_items
      @menu.add_item('New Game', callback: method(:new_game))

      player_based_menu_items.each do |mi_obj|
        next unless mi_obj.item.visible?

        @menu.add_item(mi_obj.text, callback: mi_obj.callback)
      end

      @menu.add_item('Aliens', callback: method(:show_aliens_scoreboard))
      @menu.add_item('Exit', callback: method(:exit_game))
    end

    def player_based_menu_items
      items = [OpenStruct.new(
        item: @continue_game,
        text: 'Continue',
        callback: method(:continue_game)
      )]

      items << OpenStruct.new(
        item: @load_game,
        text: 'Load Game',
        callback: method(:load_game)
      )

      items << OpenStruct.new(
        item: @leaderboard,
        text: 'Leaderboard',
        callback: method(:show_leaderboard)
      )

      items
    end

    def button_down_handled_by_frames?(id)
      return false if id == Gosu::KbEscape

      case @frames.last
      when @new_game
        @new_game.button_down(id)
        @change = @new_game.need_start
        true
      when @load_game
        @load_game.button_down(id)
        @change = @load_game.loaded
        true
      else
        false
      end
    end

    def menu_needs_to_draw?
      return false if @entrance_text.needs_redraw?
      return true if @drawed

      Timer.overtime?(MAIN_MENU_RENDER_DELAY_MSEC)
    end

    def draw_current_frame
      @frames.last.draw(*frames_drawing_options)
      @frames.shift if @frames.size > FRAMES_MAX_SIZE
      return if @frames.last == @menu

      @label_font.draw_text(
        'Press <Esc> for return to menu',
        @width * 0.35, @height * 0.95,
        0, 1.0, 1.0
      )
    end

    def exit_game
      @window.close
    end

    def show_aliens_scoreboard
      @frames.push(@aliens_scoreboard)
    end

    def frames_drawing_options
      coord_y = @entrance_text.last_y + INFO_FONT_SIZE * 1.5
      coord_x = case @frames.last
                when @menu
                  @width * 0.4
                when @aliens_scoreboard
                  @width * 0.25
                when @load_game
                  @width * 0.45
                else
                  @width * 0.35
                end
      [coord_x, coord_y]
    end

    def continue_game
      @change = true
    end

    def new_game
      @frames.push(@new_game)
    end

    def load_game
      @frames.push(@load_game)
    end

    def show_leaderboard
      @frames.push(@leaderboard)
    end
  end
end

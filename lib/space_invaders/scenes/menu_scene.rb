# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/timer'
require_relative '../menu/menu_entrance_text'
require_relative '../menu/menu'
require_relative '../menu/aliens_scoreboard'
require_relative '../menu/new_game'


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
      @menu = Menu.new(window, INFO_FONT_SIZE)
      @menu.add_item('New Game', callback: method(:new_game))
      @menu.add_item('Load Game', callback: method(:load_game))
      @menu.add_item('Leaderboard', callback: method(:show_leaderboard))
      @menu.add_item('Aliens', callback: method(:show_aliens_scoreboard))
      @menu.add_item('Exit', callback: method(:exit_game))

      @aliens_scoreboard = AliensScoreboard.new(@window, INFO_FONT_SIZE)
      @frames = [@menu]
      @label_font = Gosu::Font.new(@window, FONT, LABEL_FONT_SIZE)
      @new_game = NewGame.new(window, INFO_FONT_SIZE - 10)
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
      return @new_game.button_down(id) if @frames.last == @new_game && id != Gosu::KbBackspace
      return if @menu.needs_redraw?

      @menu.next_item if id == Gosu::KbDown
      @menu.previous_item if id == Gosu::KbUp
      @menu.run_command if id == Gosu::KbReturn
      @frames.push(@menu) if id == Gosu::KbBackspace
    end

    private

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
        'Press <Backspace> for return to menu',
        @width * 0.3, @height * 0.95,
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
                when @new_game
                  @width * 0.35
                end
      [coord_x, coord_y]
    end

    def new_game
      @frames.push(@new_game)
    end

    def load_game
      puts 'LOAD GAME!!!'
    end

    def show_leaderboard
      puts 'LEADERBOARD!!!'
    end
  end
end

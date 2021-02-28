# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/text_field'
require_relative 'menu'

module SpaceInvaders
  class NewGame
    include Settings
    CARET_COLOR = 0xffffffff

    def initialize(window, size)
      @window = window
      @font_size = size
      @font = Gosu::Font.new(window, FONT, size)
      @input = TextField.new(window)
      @input.text = 'Type new game name'
      @input.restrict = /[^a-z]/i

      @menu = Menu.new(window, size)
      @menu.add_item('Continue', callback: method(:start_game))
      @menu.reset_selection
    end

    def draw(x, y)
      @font.draw(@input.text, x, y, 0)
      top_margin = 10
      left_margin = top_margin * 6
      @menu.draw(x + left_margin, y + @font_size + top_margin)

      draw_caret(x, y)
    end

    def needs_redraw?
      true
    end

    def button_down(id)
      @input.button_down(id)
      @input.text.empty? ? @menu.reset_selection : @menu.run_selection
    end

    def start_game
      puts 'Start game'
    end

    private

    def draw_caret(x, y)
      pos_x = x + @font.text_width(@input.text[0...@input.caret_pos])
      vertical_offset = 3
      @window.draw_line(pos_x, y - vertical_offset, CARET_COLOR,
                        pos_x, y + @font_size - vertical_offset, CARET_COLOR, 0)
    end
  end
end

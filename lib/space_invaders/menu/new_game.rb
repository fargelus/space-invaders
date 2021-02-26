# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'

module SpaceInvaders
  class NewGame
    include Settings

    def initialize(window, size)
      @font = Gosu::Font.new(window, FONT, size)
      @text_input = Gosu::TextInput.new
      @text_input.text = 'Type new game name'
      @printed = false
    end

    def draw(x, y)
      @font.draw(@text_input.text, x, y, 0)
    end

    def needs_redraw?
      true
    end

    def button_down(id)
      @text_input.text = '' unless @printed
      @text_input.insert_text(id)
      @printed = true
    end
  end
end

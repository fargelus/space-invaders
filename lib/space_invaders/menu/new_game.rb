# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/text_field'

module SpaceInvaders
  class NewGame
    include Settings

    def initialize(window, size)
      @window = window
      @font = Gosu::Font.new(window, FONT, size)
      @input = TextField.new(window)
      @input.text = 'Type new game name'
      @input.restrict = /[^a-z]/i
    end

    def draw(x, y)
      @font.draw(@input.text, x, y, 0)
    end

    def needs_redraw?
      true
    end

    def button_down(id)
      @input.button_down(id)
    end
  end
end

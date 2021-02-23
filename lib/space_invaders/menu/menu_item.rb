# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'

module SpaceInvaders
  class MenuItem
    attr_reader :needs_redraw
    alias needs_redraw? needs_redraw

    def initialize(window, text, font_size)
      @text = text
      @brush = Gosu::Font.new(
        window,
        Settings::FONT,
        font_size
      )
      @needs_redraw = true
    end

    def draw(x, y)
      @brush.draw_text(@text, x, y, 0, 1.0, 1.0, Gosu::Color::WHITE)
      @needs_redraw = false
    end
  end
end

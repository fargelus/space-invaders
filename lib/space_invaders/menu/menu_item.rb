# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'

module SpaceInvaders
  class MenuItem
    attr_reader :needs_redraw
    alias needs_redraw? needs_redraw

    def initialize(window, options)
      @x = options.fetch(:x, 0)
      @y = options.fetch(:y, 0)
      @text = options.fetch(:text, '')
      @brush = Gosu::Font.new(
        window,
        Settings::FONT,
        Settings::INFO_FONT_SIZE
      )
      @needs_redraw = true
    end

    def draw
      @brush.draw_text(@text, @x, @y, 0, 1.0, 1.0, Gosu::Color::WHITE)
      @needs_redraw = false
    end
  end
end

# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'

module SpaceInvaders
  class MenuItem
    ACTIVE_COLOR = Gosu::Color.argb(0xff_de2f2f)
    DEFAULT_COLOR = Gosu::Color::WHITE

    attr_reader :needs_redraw, :text, :active, :x, :y
    alias needs_redraw? needs_redraw

    attr_accessor :scroll, :scroll_text

    def initialize(window, options)
      @text = options.fetch(:text)
      @brush = Gosu::Font.new(
        window,
        Settings::FONT,
        options.fetch(:font_size)
      )
      @active = options.fetch(:active) { false }
      @callback = options.fetch(:callback)
      @needs_redraw = true
    end

    def draw(x, y)
      @x = x
      @y = y
      color = @active ? ACTIVE_COLOR : DEFAULT_COLOR
      @brush.draw_text(scroll_text || text, x, y, 0, 1.0, 1.0, color)
      @needs_redraw = false
    end

    def active=(state)
      @active = state
      @needs_redraw = true
    end

    def scroll=(value)
      @scroll = value
      @scroll_text = nil unless value
    end

    def trigger
      @callback.call
    end
  end
end

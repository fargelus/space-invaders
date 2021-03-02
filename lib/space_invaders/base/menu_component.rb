# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

module SpaceInvaders
  class MenuComponent
    include Settings

    def initialize(window, font_size)
      @window = window
      @font_size = font_size
      @font = Gosu::Font.new(@window, FONT, @font_size)
    end

    def draw(x, y); end

    def needs_redraw?
      true
    end
  end
end

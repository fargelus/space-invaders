# frozen_string_literal: true

require 'gosu'
require_relative 'menu_item'

module SpaceInvaders
  class Menu
    def initialize(window, size)
      @window = window
      @items = []
      @font_size = size
    end

    def add_item(text)
      @items << MenuItem.new(@window, text, @font_size)
    end

    def needs_redraw?
      @items.any?(&:needs_redraw?)
    end

    def draw(start_x, start_y)
      top_margin = 10
      @items.each do |mi|
        item_y = start_y + @items.index(mi) * @font_size
        mi.draw(start_x, item_y)
        start_y += top_margin
      end
    end
  end
end

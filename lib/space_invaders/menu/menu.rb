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
        coord_x = start_x + menu_item_offset_x(mi)
        item_y = start_y + @items.index(mi) * @font_size
        mi.draw(coord_x, item_y)
        start_y += top_margin
      end
    end

    private

    def menu_item_offset_x(mi)
      char_offset_ratio = 3.6
      first_item_text_len = @items.first.text.size
      (first_item_text_len - mi.text.size) * @font_size / char_offset_ratio
    end
  end
end

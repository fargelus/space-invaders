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

    def add_item(text, callback: nil)
      @items << MenuItem.new(
        @window,
        text: text,
        font_size: @font_size,
        active: @items.empty?,
        callback: callback
      )
    end

    def next_item
      active_item, active_index = active_item_with_index
      return if active_index + 1 == @items.size

      active_item.active = false
      @items[active_index + 1].active = true
    end

    def previous_item
      active_item, active_index = active_item_with_index
      return if active_index.zero?

      active_item.active = false
      @items[active_index - 1].active = true
    end

    def run_command
      active_item_with_index[0].trigger
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

    def active_item_with_index
      active_item = @items.detect(&:active)
      active_index = @items.index(active_item)
      [active_item, active_index]
    end
  end
end

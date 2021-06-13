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

    def add_item(text, callback:)
      @items << MenuItem.new(
        @window,
        text: text,
        font_size: @font_size,
        active: @items.empty?,
        callback: callback
      )
    end

    def reset_selection
      active_item, = active_item_with_index
      active_item&.active = false
    end

    def run_selection
      @items.first&.active = true
    end

    def next_item
      active_item, active_index = active_item_with_index
      return if active_index + 1 == @items.size

      active_item.active = false
      @items[active_index + 1].active = true
    end

    def button_down(id)
      next_item if id == Gosu::KbDown
      previous_item if id == Gosu::KbUp
      run_command if id == Gosu::KbReturn
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
      calc_items_coordinates(start_x, start_y) unless @items_with_coordinates
      scroll_if_out_of_screen_by_y

      drawing_items = @items_with_coordinates.reject { |mi, _| mi.scroll }
      drawing_items.each do |mi, coords|
        mi.draw(coords[0], coords[1])
      end

      scroll_items_trigger = @items_with_coordinates.select { |mi, *| mi.scroll }
                                                    .min_by { |_, coords| coords[1] }
      if scroll_items_trigger
        scroll_coords = scroll_items_trigger[1]
        scroll_items_trigger[0].draw(scroll_coords[0], scroll_coords[1])
      end
    end

    def active_item
      @items.detect(&:active)
    end

    private

    def calc_items_coordinates(initial_x, initial_y)
      @items_with_coordinates = {}
      @items.each_with_index do |item, index|
        coord_x = initial_x + menu_item_offset_x(item)
        coord_y = initial_y + index * @font_size
        @items_with_coordinates[item] = [coord_x, coord_y]
      end
    end

    def scroll_if_out_of_screen_by_y
      screen_out_y = @window.height * 0.8
      @items.each { |mi| mi.scroll = false }
      @items_with_coordinates.each do |item, coords|
        coord_y = coords[1]
        if coord_y > screen_out_y
          item.scroll = true
          item.scroll_text = '...'
        end
      end
    end

    def menu_item_offset_x(mi)
      first_item_text_len = @items.first.text.size
      (first_item_text_len - mi.text.size) * @font_size / Settings::CHAR_OFFSET_RATIO
    end

    def active_item_with_index
      [active_item, @items.index(active_item)]
    end
  end
end

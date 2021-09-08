# frozen_string_literal: true

require_relative 'menu'

module SpaceInvaders
  class ScrollableMenu < Menu
    SCROLL_Y_OFFSET_BASE = 30

    attr_reader :drawing_items

    def draw(start_x, start_y)
      calc_items_coordinates(start_x, scroll_y(start_y))
      scroll_if_out_of_screen_by_y

      drawing_items.each do |mi, coords|
        mi.draw(coords[0], coords[1])
      end

      draw_scroll_trigger
    end

    private

    def scroll_y(drawing_y)
      @scroll_coords ||= [drawing_y]
      if scroll_bottom?
        new_coord = @scroll_coords.last - SCROLL_Y_OFFSET_BASE
        @scroll_coords.push(new_coord)
        new_coord
      else
        @scroll_coords.last
      end
    end

    def scroll_bottom?
      if @bottom_scrolled_coords.nil? || @items_with_coordinates.empty?
        return false
      end

      bottom_scrolled_items = @items_with_coordinates.select { |_, coords| @bottom_scrolled_coords.include? coords[1] }
      bottom_scrolled_items.any? { |item, _| item.active }
    end

    def scroll_if_out_of_screen_by_y
      screen_max_out_y = @window.height * 0.8
      screen_min_out_y = @window.height * 0.35
      @bottom_scrolled_coords = []
      @top_scrolled_coords = []
      @drawing_items = {}

      @items_with_coordinates.each do |item, coords|
        coord_y = coords[1]

        if coord_y < screen_max_out_y && coord_y > screen_min_out_y
          @drawing_items[item] = coords
          next
        end

        value = Hash[scrollable_menu_item, coord_y]
        if coord_y > screen_max_out_y
          @bottom_scrolled_coords.push(value)
        else
          @top_scrolled_coords.push(value)
        end

        break if @bottom_scrolled_coords.any? || @top_scrolled_coords.any?
      end
    end

    def scrollable_menu_item
      MenuItem.new(
        @window,
        text: '...',
        font_size: @font_size,
        active: false,
        callback: nil
      )
    end

    def draw_scroll_trigger
      min_size_item = @items_with_coordinates.max_by { |_, coords| coords[0] }.first
      scroll_coords = [@bottom_scrolled_coords, @top_scrolled_coords].flatten.compact

      scroll_coords.each do |scrollable|
        scrollable.each { |mi, scroll_y| mi.draw(min_size_item.x, scroll_y) }
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'menu'

module SpaceInvaders
  class ScrollableMenu < Menu
    SCROLL_Y_OFFSET_BASE = 30

    attr_reader :drawing_items

    def draw(start_x, start_y)
      calc_items_coordinates(start_x, scroll_y(start_y))
      draw_visible_items
      draw_scrollable_items
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

    def draw_visible_items
      @items_with_coordinates.select { |item, coords| visible_item?(coords[1]) }
                             .each { |item, coords| item.draw(coords[0], coords[1]) }
    end

    def visible_item?(coord_y)
      coord_y < screen_max_out_y && coord_y > screen_min_out_y
    end

    def screen_max_out_y
      @window.height * 0.8
    end

    def screen_min_out_y
      @window.height * 0.35
    end

    def draw_scrollable_items
      top_scrolled_coords = []
      bottom_scrolled_coords = []
      @items_with_coordinates.reject { |*, coords| visible_item?(coords[1]) }
                             .each do |item, coords|
                               coord_y = coords[1]
                               top_scrolled_coords << coord_y if coord_y < screen_min_out_y
                               bottom_scrolled_coords << coord_y if coord_y > screen_max_out_y
                             end

      min_size_item = @items_with_coordinates.max_by { |_, coords| coords[0] }.first
      scroll_coords = [bottom_scrolled_coords.min, top_scrolled_coords.max].compact
      scroll_coords.each { |scroll_y| scrollable_menu_item.draw(min_size_item.x, scroll_y) }
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
  end
end

# frozen_string_literal: true

require_relative 'menu'

module SpaceInvaders
  class ScrollableMenu < Menu
    SCROLL_Y_OFFSET_BASE = 30

    def draw(start_x, start_y)
      calc_items_coordinates(start_x, scroll_y(start_y))
      scroll_if_out_of_screen_by_y

      drawing_items = @items_with_coordinates.reject { |mi, _| mi.scroll }
      drawing_items.each do |mi, coords|
        mi.draw(coords[0], coords[1])
      end

      draw_scroll_trigger
    end

    private

    def scroll_y(drawing_y)
      @scroll_coords ||= [drawing_y]
      if need_scroll?
        new_coord = @scroll_coords.last - SCROLL_Y_OFFSET_BASE
        @scroll_coords.push(new_coord)
        new_coord
      else
        @scroll_coords.last
      end
    end

    def need_scroll?
      scrollable_item = first_scrollable_item
      return false unless scrollable_item

      scrollable_trigger = scrollable_item[0]
      return false unless scrollable_trigger.active

      true
    end

    def first_scrollable_item
      scrolled_items = @items_with_coordinates.select { |mi, *| mi.scroll }
      return if scrolled_items.empty?

      scrollable_trigger = scrolled_items.min_by { |_, coords| y = coords[1] }
      scrollable_trigger || scrolled_items.max_by { |_, coords| y = coords[1] }
    end

    def scroll_if_out_of_screen_by_y
      screen_max_out_y = @window.height * 0.8
      @items.each { |mi| mi.scroll = false }

      @items_with_coordinates.each do |item, coords|
        coord_y = coords[1]
        if coord_y > screen_max_out_y
          item.scroll = true
          item.scroll_text = '...'
        end
      end
    end

    def draw_scroll_trigger
      scrolled_items = @items_with_coordinates.select { |mi, *| mi.scroll }
      min_size_item = @items_with_coordinates.max_by { |_, coords| coords[0] }.first
      scroll_items_trigger = @items_with_coordinates.select { |mi, *| mi.scroll }
                                                    .min_by { |_, coords| coords[1] }
      if scroll_items_trigger
        scroll_coords = scroll_items_trigger[1]
        scroll_items_trigger[0].draw(min_size_item.x, scroll_coords[1])
      end
    end
  end
end

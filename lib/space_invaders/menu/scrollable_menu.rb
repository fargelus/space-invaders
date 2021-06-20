# frozen_string_literal: true

require_relative 'menu'

module SpaceInvaders
  class ScrollableMenu < Menu
    def draw(start_x, start_y)
      if need_recalc_coordinates?
        calc_items_coordinates(start_x, scroll_y(start_y))
      end
      scroll_if_out_of_screen_by_y

      drawing_items = @items_with_coordinates.reject { |mi, _| mi.scroll }
      drawing_items.each do |mi, coords|
        mi.draw(coords[0], coords[1])
      end

      draw_scroll_trigger
    end

    private

    def need_recalc_coordinates?
      return true if @items_with_coordinates.empty?

      need_scroll?
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

    def scroll_y(drawing_y)
      return drawing_y unless need_scroll?

      drawing_y - 30
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

    def draw_scroll_trigger
      scroll_items_trigger = @items_with_coordinates.select { |mi, *| mi.scroll }
                                                    .min_by { |_, coords| coords[1] }
      if scroll_items_trigger
        scroll_coords = scroll_items_trigger[1]
        scroll_items_trigger[0].draw(scroll_coords[0], scroll_coords[1])
      end
    end
  end
end

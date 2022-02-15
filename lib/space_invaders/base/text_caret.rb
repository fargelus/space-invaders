# frozen_string_literal: true

require_relative 'timer'

module SpaceInvaders
  class TextCaret
    CARET_COLOR = 0xffffffff
    CARET_DELAY_MSEC = 500
    VERTICAL_OFFSET = 3

    def initialize(window)
      @window = window
      @visible = true
    end

    def draw(options)
      if Timer.overtime?(CARET_DELAY_MSEC)
        @visible = !@visible
      end

      draw_visible(options) if @visible
    end

    private

    def draw_visible(options)
      pos_x = options.fetch(:x) + options.fetch(:text_width)
      text_height = options.fetch(:text_height)
      y = options.fetch(:y)
      @window.draw_line(pos_x, y - VERTICAL_OFFSET, CARET_COLOR,
                        pos_x, y + text_height - VERTICAL_OFFSET,
                        CARET_COLOR, 0)
    end
  end
end

# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'

module SpaceInvaders
  class PrintableText
    DELAY_DRAW_MSEC = 70

    def initialize(options)
      @full_text = options[:text].upcase
      @chars_to_draw = 1
      @x = options[:x]
      @y = options[:y]
      @color = options[:color] || Gosu::Color::WHITE
      @printable_obj = Gosu::Font.new(
        options[:window],
        Settings::FONT,
        options[:size]
      )
    end

    def needs_redraw?
      @chars_to_draw <= @full_text.size
    end

    def draw
      drawing_text = @full_text.slice(0, @chars_to_draw)
      @printable_obj.draw_text(drawing_text, @x, @y, 0, 1.0, 1.0, @color)
      return if Gosu.milliseconds - @last_draw_timestamp.to_i < DELAY_DRAW_MSEC

      @chars_to_draw += 1
      @last_draw_timestamp = Gosu.milliseconds
    end
  end
end

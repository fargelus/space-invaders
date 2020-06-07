# frozen_string_literal: true

require 'gosu'

class PrintableText
  DELAY_DRAW_MSEC = 40

  def initialize(options)
    @full_text = options[:text]
    @drawing_text = @full_text[0]
    @draws = 0
    @x = options[:x]
    @y = options[:y]
    @color = options[:color] || Gosu::Color::WHITE
    @printable_obj = Gosu::Font.new(
      options[:window],
      Gosu.default_font_name,
      options[:size]
    )
  end

  def needs_redraw?
    return false if @draws >= @full_text.size

    Gosu.milliseconds - @last_draw_timestamp.to_i > DELAY_DRAW_MSEC
  end

  def draw
    @draws += 1
    drawing_text = @full_text.slice(0, @draws)
    @printable_obj.draw_text(drawing_text, @x, @y, 0, 1.0, 1.0, @color)
    @last_draw_timestamp = Gosu.milliseconds
  end
end

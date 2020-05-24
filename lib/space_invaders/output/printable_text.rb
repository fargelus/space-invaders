# frozen_string_literal: true

require 'gosu'

class PrintableText
  def initialize(options)
    @full_text = options[:text]
    @text = @full_text[0]
    @draws = 0
    @x = options[:x]
    @y = options[:y]
    @printable_obj = Gosu::Font.new(
      options[:window],
      Gosu.default_font_name,
      50
    )
  end

  def needs_redraw?
    @text != @full_text
  end

  def draw
    color = Gosu::Color.new(214, 17, 17)
    @printable_obj.draw_text(@text, @x, @y, 0, 1.0, 1.0, color)
    @draws += 1
    @text += @full_text[@draws] if @draws < @full_text.size
  end
end

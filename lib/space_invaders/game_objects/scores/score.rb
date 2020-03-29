# frozen_string_literal: true

require 'gosu'

module SpaceInvaders
  class Score
    def initialize(options)
      @x = options[:x] || 0
      @y = options[:y] || 0
      @score_obj = Gosu::Font.new(
        options[:window],
        Gosu.default_font_name,
        25
      )
      @score_text = ''
      @score = 0
    end

    def draw
      @score_obj.draw_text("#{@score_text}: #{@score}", @x, @y, 0)
    end

    def up
      @score += 10
    end
  end
end

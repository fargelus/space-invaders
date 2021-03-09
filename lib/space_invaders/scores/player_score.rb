# frozen_string_literal: true

require_relative 'score'
require_relative '../base/settings'

module SpaceInvaders
  class PlayerScore < Score
    def initialize(options)
      super
      @score_text = 'SCORE'
      @score = 0
    end

    def draw(current_user)
      @score_obj.draw_text("User: #{current_user}", @x, @y, 0, 1, 1, Settings::GREEN_COLOR)
      @score_obj.draw_text("#{@score_text}: #{@score}", @x, @y + @font_size, 0)
    end

    def current
      @score
    end
  end
end

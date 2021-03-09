# frozen_string_literal: true

require_relative 'score'
require_relative '../db/operations'

module SpaceInvaders
  class HiScore < Score
    def initialize(options)
      super
      @score_text = 'RECORD'
    end

    def draw(current_user)
      @hi_score ||= DBOperations.user_record(current_user)
      @score_obj.draw_text("#{@score_text}: #{@hi_score}", @x, @y, 0)
    end
  end
end

# frozen_string_literal: true

require_relative 'score'

module SpaceInvaders
  class PlayerScore < Score
    def initialize(options)
      super
      @score_text = 'SCORE'
      @score = 0
    end

    def current
      @score
    end
  end
end

# frozen_string_literal: true

require_relative 'score'

module SpaceInvaders
  class HiScore < Score
    def initialize(options)
      super
      @score = 100
      @score_text = 'MAX SCORE'
    end
  end
end

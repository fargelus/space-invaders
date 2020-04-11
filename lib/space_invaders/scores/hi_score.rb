# frozen_string_literal: true

require 'mongo'
require_relative 'score'
require_relative '../base/settings'

module SpaceInvaders
  class HiScore < Score
    def initialize(options)
      super
      @score = fetch_score_from_db || 0
      @score_text = 'MAX SCORE'
    end

    private

    def fetch_score_from_db
      Settings::SCORES_COLLECTION.find().sort(scores: -1).first()[:score]
    end
  end
end

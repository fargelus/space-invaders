# frozen_string_literal: true

require_relative 'score'
require_relative '../db/setup'

module SpaceInvaders
  class HiScore < Score
    def initialize(options)
      super
      @score = fetch_score_from_db || 0
      @score_text = 'MAX SCORE'
    end

    private

    def fetch_score_from_db
      # rubocop:disable Style/UnneededSort
      doc = DB::SCORES_COLLECTION.find({}).sort(score: -1).first
      doc[:score] if doc
    end
  end
end

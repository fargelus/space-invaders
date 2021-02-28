# frozen_string_literal: true

require_relative 'setup'

module SpaceInvaders
  class DBOperations
    class << self
      include DB

      def insert_to_scores(data)
        SCORES_COLLECTION.insert_one(data)
      rescue Mongo::Error::OperationFailure
        nil
      end
    end
  end
end

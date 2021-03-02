# frozen_string_literal: true

require_relative 'setup'

module SpaceInvaders
  class DBOperations
    class Errors
      class OperationFailure < Mongo::Error::OperationFailure; end
    end

    class << self
      include DB

      def insert_to_scores(data)
        SCORES_COLLECTION.insert_one(data)
      rescue Mongo::Error::OperationFailure
        raise Errors::OperationFailure
      end

      def find_max_scores(limit)
        SCORES_COLLECTION.find.sort(score: -1).limit(limit)
      end
    end
  end
end

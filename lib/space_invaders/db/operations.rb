# frozen_string_literal: true

require_relative 'setup'

module SpaceInvaders
  class DBOperations
    class Errors
      class OperationFailure < Mongo::Error::OperationFailure; end
    end

    class << self
      include DB

      def insert(data)
        SCORES_COLLECTION.insert_one(data)
      rescue Mongo::Error::OperationFailure
        raise Errors::OperationFailure
      end

      def find_max_scores(limit)
        SCORES_COLLECTION.find.sort(score: -1).limit(limit)
      end

      def reset_previous_session
        SCORES_COLLECTION.find_one_and_update({ active: true }, '$set': { active: false })
      end

      def current_user
        SCORES_COLLECTION.find(active: true)&.first[:user]
      end

      def user_record(user)
        SCORES_COLLECTION.find(user: user).sort(score: -1).first[:score]
      end
    end
  end
end

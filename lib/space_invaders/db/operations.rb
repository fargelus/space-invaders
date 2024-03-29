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
      rescue Mongo::Error::OperationFailure => e
        raise Errors::OperationFailure e&.msg
      end

      def update(data)
        SCORES_COLLECTION.update_one(
          { 'user' => data[:user] },
          { '$set' => { score: data[:score] } }
        )
      rescue Mongo::Error::OperationFailure => e
        raise Errors::OperationFailure e&.msg
      end

      def find_max_scores(limit)
        SCORES_COLLECTION.find.sort(score: -1).limit(limit + 1)
      end

      def reset_previous_session
        SCORES_COLLECTION.find_one_and_update({ active: true }, '$set': { active: false })
      end

      def turn_session(session_name)
        SCORES_COLLECTION.find_one_and_update({ user: session_name }, '$set': { active: true })
      end

      def current_user
        SCORES_COLLECTION.find(active: true)&.first&.send(:[], 'user')
      end

      def user_record(user)
        SCORES_COLLECTION.find(user: user).sort(score: -1).first[:score]
      end

      def all_records
        SCORES_COLLECTION.find({})
      end
    end
  end
end

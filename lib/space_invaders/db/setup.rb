# frozen_string_literal: true

require 'mongo'

module SpaceInvaders
  module DB
    CONNECTION = Mongo::Client.new(
      ["#{ENV['MONGO_HOST']}:#{ENV['MONGO_PORT']}"],
      database: ENV['MONGO_DB']
    )
    SCORES_COLLECTION = CONNECTION[:scores]
    SCORES_COLLECTION.indexes.create_one({ user: 1 }, unique: true)
  end
end

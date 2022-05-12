# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

module SpaceInvaders
  module Helpers
    def max_x_coord(collection)
      collection.max_by(&:x).x
    end

    def min_x_coord(collection)
      collection.min_by(&:x).x
    end
  end
end

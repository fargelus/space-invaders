# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

module SpaceInvaders
  module Helpers
    def horizontal_center(obj)
      Settings::WIDTH / 2 - obj.w / 2
    end

    def timeout?(timestamp, duration)
      Gosu.milliseconds - timestamp > duration
    end

    def last_column_x(collection)
      collection.max_by(&:x).x
    end

    def first_column_x(collection)
      collection.min_by(&:x).x
    end
  end
end

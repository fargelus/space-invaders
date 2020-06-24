# frozen_string_literal: true

require 'gosu'

module SpaceInvaders
  class Timer
    def self.overtime?(duration)
      @timestamp ||= Gosu.milliseconds
      result = Gosu.milliseconds - @timestamp > duration
      @timestamp = nil if result
      result
    end
  end
end

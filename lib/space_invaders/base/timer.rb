# frozen_string_literal: true

require 'gosu'

module SpaceInvaders
  class Timer
    def self.overtime?(duration, freeze: nil)
      @timestamp ||= Gosu.milliseconds
      result = Gosu.milliseconds - @timestamp > duration
      @timestamp = nil if result && !freeze
      result
    end
  end
end

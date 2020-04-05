# frozen_string_literal: true

require_relative 'settings'

module SpaceInvaders
  module Helpers
    def horizontal_center(obj)
      Settings::WIDTH / 2 - obj.w / 2
    end
  end
end

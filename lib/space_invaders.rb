# frozen_string_literal: true

require 'gosu'
require_relative 'space_invaders/version'

module SpaceInvaders
  class Game < Gosu::Window
    def initialize(width = 640, height = 480)
      super
      self.caption = 'Space Invaders'
    end
  end
end

game = SpaceInvaders::Game.new
game.show

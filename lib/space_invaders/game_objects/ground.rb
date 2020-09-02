# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'

module SpaceInvaders
  class Ground
    HEIGHT = 5
    COLOR = Gosu::Color.new(133, 104, 66)

    attr_reader :x, :y

    def initialize(coord_x, coord_y)
      @x = coord_x
      @y = coord_y
    end

    def draw
      Gosu.draw_rect(@x, @y, Settings::WIDTH, HEIGHT, COLOR)
    end
  end
end

# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

class Ship
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
    @ship_path = SpaceInvaders::Settings.images_path('ship.png')
    @ship = Gosu::Image.new(@ship_path)
  end

  def draw
    @ship.draw(@x, @y, 0)
  end
end

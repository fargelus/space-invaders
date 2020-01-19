# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

class Ship
  attr_reader :x, :y, :width, :height
  alias w width
  alias h height

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
    @ship_path = SpaceInvaders::Settings.images_path('ship.png')
    @ship = Gosu::Image.new(@ship_path)
    @width = @ship.width
    @height = @ship.height
  end

  def set(x, y)
    @x = x
    @y = y
  end

  def draw
    @ship.draw(@x, @y, 0)
  end
end

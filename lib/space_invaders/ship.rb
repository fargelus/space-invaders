# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

class Ship
  attr_reader :x, :y, :w, :h

  def initialize(x = 0, y = 0, boundaries = [])
    @x = x
    @y = y
    @boundaries = boundaries
    @speed = SpaceInvaders::Settings::SPACESHIP_SPEED

    ship_path = SpaceInvaders::Settings.images_path('ship.png')
    @ship = Gosu::Image.new(ship_path)
    @w = @ship.width
    @h = @ship.height
    @position_changed = false
  end

  def set(x, y, boundaries)
    @x = x
    @y = y
    @boundaries = boundaries
    @position_changed = true
  end

  def needs_redraw?
    @position_changed
  end

  def draw
    @ship.draw(@x, @y, 0)
    @position_changed = false
  end

  def move_left!
    set(@x - @speed, @y, @boundaries) if @x > @boundaries.min
  end

  def move_right!
    set(@x + @speed, @y, @boundaries) if @x + @w < @boundaries.max
  end
end

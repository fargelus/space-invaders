# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

module SpaceInvaders
  class Ship
    attr_reader :x, :y, :w, :h

    SHIP_IMAGE_PATH = Settings::IMAGES_PATH / 'ship.png'

    def initialize(x = 0, y = 0, boundaries = [])
      @x = x
      @y = y
      @boundaries = boundaries
      @speed = Settings::SPACESHIP_SPEED

      @ship = Gosu::Image.new(SHIP_IMAGE_PATH.to_s)
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
end

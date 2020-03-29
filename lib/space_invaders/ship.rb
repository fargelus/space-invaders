# frozen_string_literal: true

require 'gosu'
require_relative 'settings'
require_relative 'game_object'
require_relative 'gun'

module SpaceInvaders
  class Ship < GameObject
    SHIP_IMAGE_PATH = Settings::IMAGES_PATH / 'ship.png'
    attr_writer :enemies

    def initialize(x = 0, y = 0, boundaries = [])
      super x, y, SHIP_IMAGE_PATH

      @boundaries = boundaries
      @speed = Settings::SPACESHIP_SPEED
      @position_changed = false
      @enemies = []

      @gun = Gun.new
    end

    def set(x, y, boundaries)
      super x, y
      @boundaries = boundaries
      @position_changed = true
      @gun.set(x + @w / 2 - @gun.w / 2, y, @enemies)
    end

    def needs_redraw?
      @position_changed || @gun.needs_redraw?
    end

    def draw
      super
      @position_changed = false
      @gun.draw
    end

    def move_left!
      set(@x - @speed, @y, @boundaries) if @x > @boundaries.min
    end

    def move_right!
      set(@x + @speed, @y, @boundaries) if @x + @w < @boundaries.max
    end

    def shoot
      @gun.shoot!
    end
  end
end

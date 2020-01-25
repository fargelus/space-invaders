# frozen_string_literal: true

require 'gosu'
require_relative 'settings/settings'
require_relative 'game_object'

module SpaceInvaders
  class Ship < GameObject
    SHIP_IMAGE_PATH = AssetsSettings::IMAGES_PATH / 'ship.png'

    def initialize(x = 0, y = 0, boundaries = [])
      super x, y, SHIP_IMAGE_PATH

      @boundaries = boundaries
      @speed = Settings::SPACESHIP_SPEED
      @position_changed = false
    end

    def set(x, y, boundaries)
      super x, y
      @boundaries = boundaries
      @position_changed = true
    end

    def needs_redraw?
      @position_changed
    end

    def draw
      super
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

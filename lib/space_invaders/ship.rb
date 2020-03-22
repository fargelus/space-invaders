# frozen_string_literal: true

require 'gosu'
require_relative 'settings'
require_relative 'game_object'
require_relative 'bullet'

module SpaceInvaders
  class Ship < GameObject
    SHIP_IMAGE_PATH = Settings::IMAGES_PATH / 'ship.png'

    def initialize(x = 0, y = 0, boundaries = [])
      super x, y, SHIP_IMAGE_PATH

      @boundaries = boundaries
      @speed = Settings::SPACESHIP_SPEED
      @position_changed = false

      @bullet = Bullet.new
    end

    def set(x, y, boundaries)
      super x, y
      @boundaries = boundaries
      @position_changed = true
      reload
    end

    def needs_redraw?
      @position_changed || @bullet.needs_redraw?
    end

    def draw
      super
      @position_changed = false
      target? ? @bullet.draw : reload
    end

    def move_left!
      set(@x - @speed, @y, @boundaries) if @x > @boundaries.min
    end

    def move_right!
      set(@x + @speed, @y, @boundaries) if @x + @w < @boundaries.max
    end

    def shoot(target)
      @bullet.moving = true
      @target = target
    end

    private

    def reload
      @bullet.moving = false
      @target = nil
      @bullet.set(@x + @w / 2 - @bullet.w / 2, @y)
    end

    def target?
      @bullet.moves? && @target < @bullet.y
    end
  end
end

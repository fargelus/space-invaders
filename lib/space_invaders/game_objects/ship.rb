# frozen_string_literal: true

require 'gosu'
%w[settings game_object].each do |fn|
  require_relative "../base/#{fn}"
end
require_relative 'gun'

module SpaceInvaders
  class Ship < GameObject
    SHIP_IMAGE_PATH = Settings::IMAGES_PATH / 'ship.png'
    attr_writer :enemies
    attr_reader :lifes

    def initialize(coord_x = 0, coord_y = 0, boundaries = [])
      super coord_x, coord_y, SHIP_IMAGE_PATH

      @boundaries = boundaries
      @speed = Settings::SPACESHIP_SPEED
      @position_changed = false
      @enemies = []
      @lifes = Settings::SPACESHIP_LIFES

      @gun = Gun.new(
        shot_sound_path: Settings::SOUNDS_PATH / 'spaceship_gun.wav',
        bullet_image_path: Settings::BULLETS_DIR / 'bullet.png'
      )
    end

    def set(coord_x, coord_y, boundaries)
      super coord_x, coord_y
      @boundaries = boundaries
      @position_changed = true
      @gun.set(coord_x + @w / 2 - @gun.w / 2, coord_y)
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
      target = @enemies.find(@x)
      @gun.shoot!(target)
    end
  end
end

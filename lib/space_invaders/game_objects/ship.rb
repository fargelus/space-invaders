# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/game_object'
require_relative 'gun'

module SpaceInvaders
  class Ship < GameObject
    SHIP_IMAGE_PATH = Settings::IMAGES_PATH / 'ship.png'
    HIT_SOUND = Settings::SOUNDS_PATH / 'ship_hit.wav'
    DESTROY_SOUND = Settings::SOUNDS_PATH / 'ship_destroys.wav'
    BLINK_DURATION_MSEC = 250

    attr_writer :enemies
    attr_reader :lifes

    def initialize(coord_x = 0, coord_y = 0, boundaries = [])
      super coord_x, coord_y, SHIP_IMAGE_PATH

      @boundaries = boundaries
      @speed = Settings::SPACESHIP_SPEED
      @redraw = false
      @enemies = []
      @lifes = Settings::SPACESHIP_LIFES
      @hit_sound = Gosu::Sample.new(HIT_SOUND)

      @gun = Gun.new(
        shot_sound_path: Settings::SOUNDS_PATH / 'spaceship_gun.wav',
        bullet_image_path: Settings::BULLETS_DIR / 'bullet.png',
        direction: Settings::BULLET_DIRECTION_UP
      )
    end

    def set(coord_x, coord_y, boundaries)
      super coord_x, coord_y
      @boundaries = boundaries
      @redraw = true
      @gun.set(coord_x + @w / 2 - @gun.w / 2, coord_y)
    end

    def needs_redraw?
      @redraw || @gun.needs_redraw?
    end

    def area?(coord_x, coord_y)
      return false if @y + @h > coord_y

      @x + w >= coord_x && coord_x > @x
    end

    def destroy
      @lifes -= 1
      volume = Settings::SOUNDS_VOLUME
      @lifes.positive? ? @hit_sound.play(volume)
                       : Gosu::Sample.new(DESTROY_SOUND).play(volume)
      @redraw = true
      @destroyed_timestamp = Gosu.milliseconds
    end

    def draw
      return if blinking?

      super
      @redraw = false
      @gun.re_target!(@enemies.find(@gun.x))
      @gun.draw
    end

    def move_left!
      set(@x - @speed, @y, @boundaries) if @x > @boundaries.min
    end

    def move_right!
      set(@x + @speed, @y, @boundaries) if @x + @w < @boundaries.max
    end

    def shoot
      @gun.shoot!(@enemies.find(@gun.x))
    end

    private

    def blinking?
      return false unless @destroyed_timestamp

      now = Gosu.milliseconds
      blink = now - @destroyed_timestamp < BLINK_DURATION_MSEC
      @destroyed_timestamp = nil unless blink
      blink
    end
  end
end

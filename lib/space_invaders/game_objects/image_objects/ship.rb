# frozen_string_literal: true

require 'gosu'
require_relative '../../base/settings'
require_relative '../../base/image_object'
require_relative '../../effects/explosion'
require_relative 'gun'

module SpaceInvaders
  class Ship < ImageObject
    include Settings

    SHIP_IMAGE_PATH = IMAGES_PATH / 'ship.png'
    HIT_SOUND = SOUNDS_PATH / 'ship_hit.wav'
    DESTROY_SOUND = SOUNDS_PATH / 'ship_destroys.wav'
    BLINK_DURATION_MSEC = 250

    attr_writer :enemies
    attr_reader :lifes

    def initialize(coord_x = 0, coord_y = 0, boundaries = [])
      super coord_x, coord_y, SHIP_IMAGE_PATH

      @boundaries = boundaries
      @redraw = false
      @enemies = []
      @lifes = SPACESHIP_LIFES
      @hit_sound = Gosu::Sample.new(HIT_SOUND)

      @gun = Gun.new(gun_options)
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

    def start_y
      ship_margin_top = 5
      y - h / 2 - ship_margin_top
    end

    def area?(coord_x, coord_y)
      return false if @y + @h > coord_y

      @x + w >= coord_x && coord_x > @x
    end

    def destroy
      @lifes -= 1
      @hit_sound.play(SOUNDS_VOLUME) if @lifes.positive?
      Gosu::Sample.new(DESTROY_SOUND).play(SOUNDS_VOLUME) if @lifes.zero?

      @redraw = true
      @destroyed_timestamp = Gosu.milliseconds
      @explosion = Explosion.new(@x, @y) if @lifes.zero?
    end

    def draw
      return @explosion.draw if @explosion
      return if blinking?

      super
      @redraw = false
      @destroyed_timestamp = nil
      @gun.re_target!(@enemies.find(@gun.x))
      @gun.draw
    end

    def move_left!
      set(@x - SPACESHIP_SPEED, @y, @boundaries) if @x > @boundaries.min
    end

    def move_right!
      set(@x + SPACESHIP_SPEED, @y, @boundaries) if @x + @w < @boundaries.max
    end

    def shoot
      @gun.shoot!(@enemies.find(@gun.x))
    end

    def destroyed?
      @explosion && !@explosion.needs_redraw?
    end

    private

    def gun_options
      {
        shot_sound_path: SOUNDS_PATH / 'spaceship_gun.wav',
        bullet_image_path: BULLETS_DIR / 'bullet.png',
        direction: BULLET_DIRECTION_UP
      }
    end

    def blinking?
      now = Gosu.milliseconds
      @destroyed_timestamp && now - @destroyed_timestamp < BLINK_DURATION_MSEC
    end
  end
end

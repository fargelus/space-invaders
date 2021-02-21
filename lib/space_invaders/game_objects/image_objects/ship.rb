# frozen_string_literal: true

require 'gosu'
require_relative '../../base/settings'
require_relative '../../base/image_object'
require_relative '../../effects/explosion'

module SpaceInvaders
  class Ship < ImageObject
    include Settings

    SHIP_IMAGE_PATH = IMAGES_PATH / 'ship.png'
    HIT_SOUND = SOUNDS_PATH / 'ship_hit.wav'
    DESTROY_SOUND = SOUNDS_PATH / 'ship_destroys.wav'
    BLINK_DURATION_MSEC = 250

    attr_writer :enemies
    attr_reader :lifes

    def initialize(options)
      super options.fetch(:x, 0), options.fetch(:y, 0), SHIP_IMAGE_PATH

      @boundaries = options.fetch(:boundaries, [])
      @redraw = false
      @enemies = []
      @lifes = SPACESHIP_LIFES
      @hit_sound = Gosu::Sample.new(HIT_SOUND)

      @gun = options[:ammo]
    end

    def set(coord_x, coord_y, boundaries)
      super coord_x, coord_y
      @boundaries = boundaries
      @redraw = true
      @gun.set(@x + @w / 2 - @gun.w / 2, @y)
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
      retarget_gun!
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

    def blinking?
      now = Gosu.milliseconds
      @destroyed_timestamp && now - @destroyed_timestamp < BLINK_DURATION_MSEC
    end

    def retarget_gun!
      @gun.bullets_without_target do |bullet|
        bullet.target = @enemies.find(bullet.target.x)
      end
    end
  end
end

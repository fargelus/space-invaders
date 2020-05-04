# frozen_string_literal: true

require 'gosu'
require_relative 'bullet'

module SpaceInvaders
  class Gun < GameObject
    def initialize(options)
      @ammo = []
      @reload_time_msec = 100
      @prev_shoot_timestamp = Gosu.milliseconds
      @shot_sound = Gosu::Sample.new(options[:shot_sound_path])
      @bullet_image_path = options[:bullet_image_path]
      @direction = options[:direction]
    end

    def needs_redraw?
      @ammo.any?(&:needs_redraw?)
    end

    def draw
      @ammo.reject!(&:destroys?)
      @ammo.each(&:draw)
    end

    def shoot!(target)
      @prev_shoot_timestamp ||= Gosu.milliseconds
      return unless ready_for_shoot?

      @prev_shoot_timestamp = nil
      @ammo << Bullet.new(
        x: @x,
        y: @y,
        image_path: @bullet_image_path,
        direction: @direction
      )
      @ammo.last.move(target)
      @shot_sound.play(Settings::SOUNDS_VOLUME)
    end

    def w
      Settings::BULLET_WIDTH
    end

    private

    def ready_for_shoot?
      Gosu.milliseconds - @prev_shoot_timestamp > @reload_time_msec
    end
  end
end

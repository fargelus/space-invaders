# frozen_string_literal: true

require 'gosu'
require_relative 'bullet'

module SpaceInvaders
  class Gun < GameObject
    SHOT_SOUND = Settings::SOUNDS_PATH / 'gun.wav'

    def initialize
      @ammo = {}
      @reload_time_msec = 100
      @prev_shoot_timestamp = Gosu.milliseconds
      @shot_sound = Gosu::Sample.new(SHOT_SOUND)
    end

    def needs_redraw?
      @ammo.keys.any?(&:needs_redraw?)
    end

    def draw
      @ammo.delete_if { |bullet, *| target_reached?(bullet) }
      @ammo.each_pair do |bullet, target|
        bullet.draw unless target_reached?(bullet)
        @targets.destroy(target.x, target.y) if target_reached?(bullet)
      end
    end

    def set(x, y, targets)
      super x, y
      @targets = targets
    end

    def shoot!
      @prev_shoot_timestamp ||= Gosu.milliseconds
      return unless ready_for_shoot?

      @prev_shoot_timestamp = nil
      bullet = Bullet.new(@x, @y)
      bullet.moving = true
      @ammo[bullet] = @targets.find(@x)
      @shot_sound.play(Settings::SOUNDS_VOLUME)
    end

    def w
      Bullet.new.w
    end

    private

    def target_reached?(bullet)
      target = @ammo[bullet]
      target && bullet.y < target.start_y
    end

    def ready_for_shoot?
      Gosu.milliseconds - @prev_shoot_timestamp > @reload_time_msec
    end
  end
end

# frozen_string_literal: true

require 'gosu'
require_relative 'bullet'

module SpaceInvaders
  class Gun < GameObject
    def initialize(options)
      @ammo = {}
      @reload_time_msec = 100
      @prev_shoot_timestamp = Gosu.milliseconds
      @shot_sound = Gosu::Sample.new(options[:shot_sound_path])
      @bullet_path = options[:bullet_image_path]
    end

    def needs_redraw?
      @ammo.keys.any?(&:needs_redraw?)
    end

    def draw
      @ammo.delete_if { |bullet, *| target_reached?(bullet) }
      @ammo.each_pair do |bullet, target|
        bullet.draw unless target_reached?(bullet)
        #take_new_target(target) if target_reached?(bullet)
      end
    end

    def shoot!(target)
      @prev_shoot_timestamp ||= Gosu.milliseconds
      return unless ready_for_shoot?

      @prev_shoot_timestamp = nil
      bullet = Bullet.new(@x, @y, @bullet_path)
      bullet.moving = true
      @ammo[bullet] = target
      @shot_sound.play(Settings::SOUNDS_VOLUME)
    end

    def w
      Settings::BULLET_WIDTH
    end

    private

    # def take_new_target(target)
    #   target.destroy(target.x, target.y)
    #   expired_ammos(target).each_key do |bullet|
    #     @ammo[bullet] = @targets.find(bullet.x)
    #   end
    # end

    def expired_ammos(target)
      @ammo.reject { |bullet, *| target_reached?(bullet) }
           .select { |*, aim| aim&.same?(target) }
    end

    def target_reached?(bullet)
      target = @ammo[bullet]
      target && bullet.y < target.start_y
    end

    def ready_for_shoot?
      Gosu.milliseconds - @prev_shoot_timestamp > @reload_time_msec
    end
  end
end

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
      @ammo.reject!(&:destroyed?)
      @ammo.each(&:draw)
    end

    def shoot!(enemy)
      return unless ready_for_shoot?

      @ammo << Bullet.new(
        x: @x,
        y: @y,
        image_path: @bullet_image_path,
        direction: @direction,
        target: enemy
      )
      @shot_sound.play(Settings::SOUNDS_VOLUME)
    end

    def w
      Settings::BULLET_WIDTH
    end

    def re_target!(new_enemy)
      destroyed_targets = @ammo.select(&:destroyed?).collect(&:target)
      return if destroyed_targets.empty?

      @ammo.reject!(&:destroyed?)
      @ammo.select { |bullet| destroyed_targets.include?(bullet.target) }
           .each { |bullet| bullet.target = new_enemy }
    end

    private

    def ready_for_shoot?
      @prev_shoot_timestamp ||= Gosu.milliseconds
      ready = Gosu.milliseconds - @prev_shoot_timestamp > @reload_time_msec
      @prev_shoot_timestamp = nil if ready
      ready
    end
  end
end

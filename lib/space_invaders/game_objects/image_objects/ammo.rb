# frozen_string_literal: true

require 'gosu'
require_relative 'bullet'
require_relative '../../base/settings'
require_relative '../../base/image_object'

module SpaceInvaders
  class Ammo < ImageObject
    def initialize(options)
      @bullets = []
      @reload_time_msec = 100
      @prev_shoot_timestamp = Gosu.milliseconds
      @shot_sound = Gosu::Sample.new(options[:shot_sound_path])
      @bullet_image_path = options[:bullet_image_path]
      @direction = options[:direction]
    end

    def needs_redraw?
      @bullets.any?(&:needs_redraw?)
    end

    def draw
      @bullets.reject!(&:destroyed?)
      @bullets.each(&:draw)
    end

    def shoot!(enemy, obstacle: nil)
      return unless ready_for_shoot?

      @bullets << Bullet.new(
        x: @x,
        y: @y,
        image_path: @bullet_image_path,
        direction: @direction,
        target: enemy,
        obstacle: obstacle
      )
      @shot_sound.play(Settings::SOUNDS_VOLUME)
    end

    def w
      Settings::BULLET_WIDTH
    end

    def bullets_without_target
      destroyed_targets = @bullets.select(&:destroyed?).collect(&:target)
      return if destroyed_targets.empty?

      @bullets.reject!(&:destroyed?)
      @bullets.select { |bullet| destroyed_targets.include?(bullet.target) }
           .each { |bullet| yield bullet }
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

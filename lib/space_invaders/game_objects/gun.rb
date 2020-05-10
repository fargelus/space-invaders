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
      reload
      @ammo.each(&:draw)
    end

    def shoot!(enemies)
      @prev_shoot_timestamp ||= Gosu.milliseconds
      return unless ready_for_shoot?

      @enemies = enemies
      @prev_shoot_timestamp = nil
      @ammo << Bullet.new(
        x: @x,
        y: @y,
        image_path: @bullet_image_path,
        direction: @direction
      )
      target = enemies.find(@x)
      @ammo.last.move_to(target)
      @shot_sound.play(Settings::SOUNDS_VOLUME)
    end

    def w
      Settings::BULLET_WIDTH
    end

    private

    def ready_for_shoot?
      Gosu.milliseconds - @prev_shoot_timestamp > @reload_time_msec
    end

    def reload
      destroyed_target = @ammo.select(&:destroys?).collect(&:target)
      @ammo.reject!(&:destroys?)
      return if destroyed_target.empty?

      @ammo.select { |bullet| destroyed_target.include?(bullet.target) }
           .each { |bullet| bullet.move_to(@enemies.find(bullet.x)) }
    end
  end
end

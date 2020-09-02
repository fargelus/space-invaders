# frozen_string_literal: true

require_relative '../../base/settings'
require_relative '../../base/image_object'

module SpaceInvaders
  class Bullet < ImageObject
    attr_accessor :target

    include Settings

    def initialize(options)
      super options[:x], options[:y], options[:image_path]
      @target = options[:target]
      @obstacle = options[:obstacle]
      @direction = options[:direction]
      @moving = true
    end

    def needs_redraw?
      @moving
    end

    def draw
      @y += (BULLET_SPEED * @direction) if @moving
      out_of_reach_bullet
      hit_target
      super if @moving
    end

    def destroyed?
      !@moving
    end

    private

    def out_of_reach_bullet
      @moving = false if stop_moving?
    end

    def stop_moving?
      if @obstacle
        obstacle_collided = @y > @obstacle.y - BULLET_HEIGHT + BULLET_SPEED
      end
      @y.negative? || @y > HEIGHT || obstacle_collided
    end

    def hit_target
      return unless @target
      return unless @target.area?(@x, @y)

      @target.destroy
      @moving = false
    end
  end
end

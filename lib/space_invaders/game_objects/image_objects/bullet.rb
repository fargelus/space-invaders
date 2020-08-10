# frozen_string_literal: true

require_relative '../../base/settings'
require_relative '../../base/image_object'

module SpaceInvaders
  class Bullet < ImageObject
    attr_accessor :target

    def initialize(options)
      super options[:x], options[:y], options[:image_path]
      @target = options[:target]
      @direction = options[:direction]
      @moving = true
    end

    def needs_redraw?
      @moving
    end

    def draw
      @y += (Settings::BULLET_SPEED * @direction) if @moving
      out_of_reach_bullet
      hit_target
      super if @moving
    end

    def destroyed?
      !@moving
    end

    private

    def out_of_reach_bullet
      @moving = false if @y.negative? || @y > Settings::HEIGHT
    end

    def hit_target
      return unless @target
      return unless @target.area?(@x, @y)

      @target.destroy
      @moving = false
    end
  end
end

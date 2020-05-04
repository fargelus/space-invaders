# frozen_string_literal: true

require_relative '../base/settings'

module SpaceInvaders
  class Bullet < GameObject
    def initialize(options)
      super options[:x], options[:y], options[:image_path]
      @moving = false
      @direction = options[:direction]
    end

    def needs_redraw?
      @moving
    end

    def draw
      @y += (Settings::BULLET_SPEED * @direction) if @moving
      hit_target
      super if @moving
    end

    def destroys?
      !@moving
    end

    def move(target)
      @moving = true
      @target = target
    end

    private

    def hit_target
      unless @target
        @moving = false if @y < 0 || @y > Settings::HEIGHT
        return
      end

      return unless @target.area?(@x, @y)

      @target.destroy
      @moving = false
    end
  end
end

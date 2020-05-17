# frozen_string_literal: true

require_relative '../base/settings'

module SpaceInvaders
  class Bullet < GameObject
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
      hit_target
      super if @moving
    end

    def destroyed?
      !@moving
    end

    private

    def hit_target
      unless @target
        @moving = false if @y < 0 || @y > Settings::HEIGHT
        return
      end

      return
      #
      # @target.destroy
      @moving = false
    end
  end
end

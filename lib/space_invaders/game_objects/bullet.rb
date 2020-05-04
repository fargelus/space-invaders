# frozen_string_literal: true

require_relative '../base/settings'

module SpaceInvaders
  class Bullet < GameObject
    def initialize(coord_x, coord_y, bullet_path)
      super coord_x, coord_y, bullet_path
      @moving = false
      @direction = Settings::BULLET_DIRECTION_UP
    end

    def needs_redraw?
      @moving
    end

    def draw
      @y += (Settings::BULLET_SPEED * @direction) if @moving
      if @target.area?(@x, @y)
        @target.destroy
        @moving = false
        return
      end

      super
    end

    def destroys?
      !@moving
    end

    def move(target)
      @moving = true
      @target = target
      @direction = Settings::BULLET_DIRECTION_DOWN if @y < @target.y
    end
  end
end

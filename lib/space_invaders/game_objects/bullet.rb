# frozen_string_literal: true

require_relative '../base/settings'

module SpaceInvaders
  class Bullet < GameObject
    attr_accessor :moving
    alias moves? moving

    def initialize(coord_x, coord_y, bullet_path)
      super coord_x, coord_y, bullet_path
      @moving = false
    end

    def needs_redraw?
      @moving
    end

    def draw
      @y -= Settings::BULLET_SPEED if @moving
      super
    end
  end
end

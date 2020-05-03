# frozen_string_literal: true

require_relative '../base/settings'

module SpaceInvaders
  class Bullet < GameObject
    attr_accessor :moving
    alias moves? moving

    BULLET_IMAGE_PATH = Settings::IMAGES_PATH / 'bullet.png'

    def initialize(coord_x = 0, coord_y = 0)
      super coord_x, coord_y, BULLET_IMAGE_PATH
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

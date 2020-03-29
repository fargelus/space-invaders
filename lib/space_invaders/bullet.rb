# frozen_string_literal: true

require_relative 'settings'

module SpaceInvaders
  class Bullet < GameObject
    attr_accessor :moving
    alias moves? moving

    BULLET_IMAGE_PATH = Settings::IMAGES_PATH / 'bullet.png'

    def initialize(x = 0, y = 0)
      super x, y, BULLET_IMAGE_PATH
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

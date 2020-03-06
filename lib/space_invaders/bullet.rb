require_relative 'settings'

module SpaceInvaders
  class Bullet < GameObject
    BULLET_IMAGE_PATH = Settings::IMAGES_PATH / 'bullet.png'

    def initialize(x = 0, y = 0)
      super x, y, BULLET_IMAGE_PATH
      @moving = false
    end

    def needs_redraw?
      @moving
    end

    def draw
      z = @moving ? 0 : -1
      @moving = false
      super z
    end

    def move!
      @moving = true
      @y -= 5
    end
  end
end

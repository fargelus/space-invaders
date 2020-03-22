require_relative 'settings'

module SpaceInvaders
  class Bullet < GameObject
    attr_reader :moving
    alias_method :moves?, :moving
    
    BULLET_IMAGE_PATH = Settings::IMAGES_PATH / 'bullet.png'

    def initialize(x = 0, y = 0)
      super x, y, BULLET_IMAGE_PATH
      @moving = false
    end

    def needs_redraw?
      @moving
    end

    def move!
      @moving = true
      @y -= 10
    end
  end
end

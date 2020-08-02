# frozen_string_literal: true

require_relative '../base/settings'
require_relative '../base/timer'

module SpaceInvaders
  class Explosion
    FRAME_DELAY_MSEC = 10
    SPRITE = Settings::EFFECTS_DIR / 'explosion.png'
    EXPLOSION_SIZE = 128

    def initialize(x, y)
      @tile_num = 0
      @x = x
      @y = y
      @tiles = Gosu::Image.load_tiles(
        SPRITE.to_s,
        EXPLOSION_SIZE,
        EXPLOSION_SIZE
      )
    end

    def needs_redraw?
      @tiles[@tile_num]
    end

    def draw
      frame = @tiles[@tile_num]
      frame&.draw(
        @x - frame.width / 3.0,
        @y - frame.height / 2.0,
        0
      )
      @tile_num += 1 if Timer.overtime?(FRAME_DELAY_MSEC)
    end
  end
end

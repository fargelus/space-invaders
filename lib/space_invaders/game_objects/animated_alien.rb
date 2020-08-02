# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative 'alien'

module SpaceInvaders
  class AnimatedAlien < Alien
    def initialize(coord_x, coord_y, alien_path)
      super coord_x, coord_y, alien_path

      @type = Settings::TILEABLE_ALIENS_PATH_TO_TYPE[alien_path]
      @tiles = Gosu::Image.load_tiles(
        alien_path.to_s,
        Settings::ALIENS_WIDTH,
        Settings::ALIENS_HEIGHT
      )
      @tile_num = 0
      @gun = Gun.new(gun_options)
    end

    def move(x, y)
      set x, y
      @tile_num += 1
      @moving = true
    end

    def needs_redraw?
      @moving
    end

    def draw
      @figure = @tiles[@tile_num % 2]
      @gun.set(@x + w / 2, @y)
      @gun.draw
      super
    end

    def shoot(enemy)
      @gun.shoot!(enemy)
    end

    private

    def gun_options
      {
        shot_sound_path: Settings::SOUNDS_PATH / 'alien_gun.wav',
        bullet_image_path: Settings::BULLETS_DIR / "#{@type}_bullet.png",
        direction: Settings::BULLET_DIRECTION_DOWN
      }
    end
  end
end

# frozen_string_literal: true

require 'gosu'
require_relative '../../base/settings'
require_relative 'alien'

module SpaceInvaders
  class AnimatedAlien < Alien
    attr_writer :gun

    def initialize(coord_x, coord_y, alien_path)
      super coord_x, coord_y, alien_path

      @type = Settings::TILEABLE_ALIENS_PATH_TO_TYPE[alien_path]
      @tiles = Gosu::Image.load_tiles(
        alien_path.to_s,
        Settings::ALIENS_WIDTH,
        Settings::ALIENS_HEIGHT
      )
      @tile_num = 0
    end

    def move(coord_x, coord_y)
      set coord_x, coord_y
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

    def shoot(enemy, obstacle)
      @gun.shoot!(enemy, obstacle: obstacle)
    end
  end
end

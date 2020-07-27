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
    end

    def move(x, y)
      super x, y
      @tile_num += 1
    end

    def draw
      @figure = @tiles[@tile_num % 2]
      super
    end
  end
end

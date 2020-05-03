# frozen_string_literal: true

require 'gosu'
%w[settings game_object].each do |fn|
  require_relative "../base/#{fn}"
end

module SpaceInvaders
  class Alien < GameObject
    DEFAULT_ALIEN = Settings::ALIENS_DIR / 'predator.png'
    attr_reader :type

    def initialize(coord_x = 0, coord_y = 0, alien_path = DEFAULT_ALIEN)
      super coord_x, coord_y, alien_path
      @type = Settings::ALIENS_PATH_TO_TYPE[alien_path]
      @figure = Gosu::Image.load_tiles(
        alien_path.to_s,
        Settings::ALIENS_WIDTH,
        Settings::ALIENS_HEIGHT
      )
      @tile_num = 0
    end

    def w
      @w / 2
    end

    def draw
      @figure[@tile_num % 2].draw(@x, @y, 0)
    end

    def area?(coord_x)
      max_x_coord = @x + w + Settings::ALIENS_MARGIN
      min_x_coord = @x - Settings::ALIENS_MARGIN / 2
      max_x_coord > coord_x && coord_x > min_x_coord
    end

    def start_y
      @y + @h
    end

    def on_move
      @tile_num += 1
    end

    def same?(alien)
      alien.x == @x && alien.y == @y
    end
  end
end

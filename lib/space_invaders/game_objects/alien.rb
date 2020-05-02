# frozen_string_literal: true

require 'gosu'
%w[settings game_object].each do |fn|
  require_relative "../base/#{fn}"
end

module SpaceInvaders
  class Alien < GameObject
    DEFAULT_ALIEN = Settings::ALIENS_DIR / 'predator.png'
    attr_reader :type

    def initialize(x = 0, y = 0, alien_path = DEFAULT_ALIEN)
      super x, y, alien_path
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

    def area?(x)
      @x + w + Settings::ALIENS_MARGIN > x && x > @x - Settings::ALIENS_MARGIN / 2
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

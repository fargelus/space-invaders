# frozen_string_literal: true

require 'gosu'
%w[settings game_object].each do |fn|
  require_relative "../base/#{fn}"
end

module SpaceInvaders
  class Alien < GameObject
    DEFAULT_ALIEN = Settings::ALIENS_DIR / 'predator.png'
    HIT_ALIEN_SOUND = Settings::SOUNDS_PATH / 'alien_destroys.wav'
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
      @destroy_sound = Gosu::Sample.new(HIT_ALIEN_SOUND)
      @gun = Gun.new(
        shot_sound_path: Settings::SOUNDS_PATH / 'alien_gun.wav',
        bullet_image_path: Settings::BULLETS_DIR / 'predator_bullet.png',
        direction: Settings::BULLET_DIRECTION_DOWN
      )
    end

    def w
      @w / 2
    end

    def needs_redraw?
      @gun.needs_redraw?
    end

    def draw
      @figure[@tile_num % 2].draw(@x, @y, 0)
      @gun.set(@x + w/2, @y)
      @gun.draw
    end    

    def area?(coord_x, coord_y)
      return false if coord_y > @y + @h || coord_y < @y

      max_x_coord = @x + w + Settings::ALIENS_MARGIN
      min_x_coord = @x - Settings::ALIENS_MARGIN / 2
      max_x_coord > coord_x && coord_x > min_x_coord
    end

    def on_move
      @tile_num += 1
    end

    def destroy
      @destroy_sound.play(Settings::SOUNDS_VOLUME)
      @killed = true
    end

    def destroys?
      @killed
    end

    def shoot(enemy)
      @gun.shoot!(enemy)
    end
  end
end

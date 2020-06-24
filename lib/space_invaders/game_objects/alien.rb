# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/game_object'

module SpaceInvaders
  class Alien < GameObject
    HIT_ALIEN_SOUND = Settings::SOUNDS_PATH / 'alien_destroys.wav'
    attr_reader :type

    def initialize(coord_x, coord_y, alien_path)
      super coord_x, coord_y, alien_path

      @type = Settings::ALIENS_PATH_TO_TYPE[alien_path]
      @destroy_sound = Gosu::Sample.new(HIT_ALIEN_SOUND)
      @gun = Gun.new(gun_options)
    end

    def w
      @w / 2
    end

    def needs_redraw?
      @moving
    end

    def draw
      super
      @gun.set(@x + w / 2, @y)
      @gun.draw
    end

    def area?(coord_x, coord_y)
      return false if coord_y > @y + @h || coord_y < @y

      max_x_coord = @x + w + Settings::ALIENS_MARGIN
      min_x_coord = @x - Settings::ALIENS_MARGIN / 2
      max_x_coord > coord_x && coord_x > min_x_coord
    end

    def on_move
      @moving = true
    end

    def destroy
      @destroy_sound.play(Settings::SOUNDS_VOLUME)
      @killed = true
    end

    def destroyed?
      @killed
    end

    def shoot(enemy)
      @gun.shoot!(enemy)
    end

    private

    def gun_options
      {
        shot_sound_path: Settings::SOUNDS_PATH / 'alien_gun.wav',
        bullet_image_path: Settings::BULLETS_DIR / 'predator_bullet.png',
        direction: Settings::BULLET_DIRECTION_DOWN
      }
    end
  end
end
